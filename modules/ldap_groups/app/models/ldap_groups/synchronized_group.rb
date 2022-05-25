require 'net/ldap'
require 'net/ldap/dn'

module LdapGroups
  class SynchronizedGroup < ApplicationRecord
    belongs_to :group

    belongs_to :auth_source

    belongs_to :filter,
               class_name: '::LdapGroups::SynchronizedFilter',
               foreign_key: :filter_id

    has_many :users,
             class_name: '::LdapGroups::Membership',
             dependent: :delete_all,
             foreign_key: 'group_id'

    validates_presence_of :dn
    validates_presence_of :group
    validates_associated :group
    validates_presence_of :auth_source

    before_destroy :remove_all_members

    ##
    # Add a set of new members to the synchronized group as well as the internal group.
    #
    # @param new_users [Array<User> | Array<Integer>] Users (or User IDs) to add to the group.
    def add_members!(new_users)
      return if new_users.empty?

      self.class.transaction do
        # create synchronized group memberships
        memberships = new_users.to_a.map { |user| { group_id: id, user_id: user_id(user) } }
        # Bulk insert the memberships to improve performance
        ::LdapGroups::Membership.insert_all memberships

        # add users to users collection of internal group
        add_members_to_group(new_users)
      end
    end

    ##
    # Remove a set of users from the synchronized group as well as the internal group.
    #
    # @param users_to_remove [Array<User> | Array<Integer>] Users (or User IDs) to remove from the group.
    def remove_members!(users_to_remove)
      return if users_to_remove.empty?

      user_ids = users_to_remove.map(&method(:user_id))

      self.class.transaction do
        # 1) Delete synchronized group MEMBERSHIPS from collection.
        users.delete users.where(user: user_ids).select(:id)

        # 2) Remove users from the internal group
        call = Groups::UpdateService
          .new(user: User.system, model: group)
          .call(user_ids: group.user_ids - user_ids)

        call.on_failure do
          Rails.logger.error "[LDAP groups] Failed to remove users #{user_ids} from #{group.name}: #{call.message}"
        end
      end
    end

    private

    def user_id(user)
      case user
      when Integer
        user
      when User
        user.id
      else
        raise ArgumentError, "Expected User or User ID (Integer) but got #{user}"
      end
    end

    def remove_all_members
      remove_members! User.find(users.pluck(:user_id))
    end

    def add_members_to_group(new_users)
      Groups::UpdateService
        .new(user: User.current, model: group)
        .call(user_ids: group.user_ids + new_users.map { |user| user_id(user) })
    end
  end
end
