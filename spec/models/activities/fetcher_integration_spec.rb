#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2022 the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See COPYRIGHT and LICENSE files for more details.
#++

require 'spec_helper'

describe Activities::Fetcher, 'integration', type: :model do
  let(:project) { create(:project) }
  let(:permissions) { %i[view_work_packages view_time_entries view_changesets view_wiki_edits] }

  let(:user) do
    create(:user,
           member_in_project: project,
           member_with_permissions: permissions)
  end

  let(:instance) { described_class.new(user, options) }
  let(:options) { {} }

  describe '#events' do
    let(:event_user) { user }
    let(:work_package) { create(:work_package, project: project, author: event_user) }
    let(:forum) { create(:forum, project: project) }
    let(:message) { create(:message, forum: forum, author: event_user) }
    let(:news) { create(:news, project: project, author: event_user) }
    let(:time_entry) { create(:time_entry, project: project, work_package: work_package, user: event_user) }
    let(:repository) { create(:repository_subversion, project: project) }
    let(:changeset) { create(:changeset, committer: event_user.login, repository: repository) }
    let(:wiki) { create(:wiki, project: project) }
    let(:wiki_page) do
      content = build(:wiki_content, page: nil, author: event_user, text: 'some text')
      create(:wiki_page, wiki: wiki, content: content)
    end

    subject { instance.events(Date.today - 30, Date.today + 1) }

    context 'activities globally' do
      let!(:activities) { [work_package, message, news, time_entry, changeset, wiki_page.content] }

      it 'finds events of all type' do
        expect(subject.map(&:journable_id))
          .to match_array(activities.map(&:id))
      end

      context 'if lacking permissions' do
        let(:permissions) { %i[] }

        it 'finds only events for which permissions are present' do
          # news and message only requires the user to be member
          expect(subject.map(&:journable_id))
            .to match_array([message.id, news.id])
        end
      end

      context 'if project has activity disabled' do
        before do
          project.enabled_module_names = project.enabled_module_names - ['activity']
        end

        it 'finds no events' do
          expect(subject.map(&:journable_id))
            .to be_empty
        end
      end

      context 'if restricting the scope' do
        before do
          options[:scope] = %w(time_entries messages)
        end

        it 'finds only events matching the scope' do
          expect(subject.map(&:journable_id))
            .to match_array([message.id, time_entry.id])
        end
      end
    end

    context 'activities in a project' do
      let(:options) { { project: project } }
      let!(:activities) { [work_package, message, news, time_entry, changeset, wiki_page.content] }

      it 'finds events of all type' do
        expect(subject.map(&:journable_id))
          .to match_array(activities.map(&:id))
      end

      context 'if lacking permissions' do
        let(:permissions) { %i[] }

        it 'finds only events for which permissions are present' do
          # news and message only requires the user to be member
          expect(subject.map(&:journable_id))
            .to match_array([message.id, news.id])
        end
      end

      context 'if project has activity disabled' do
        before do
          project.enabled_module_names = project.enabled_module_names - ['activity']
        end

        it 'finds no events' do
          expect(subject.map(&:journable_id))
            .to be_empty
        end
      end

      context 'if restricting the scope' do
        before do
          options[:scope] = %w(time_entries messages)
        end

        it 'finds only events matching the scope' do
          expect(subject.map(&:journable_id))
            .to match_array([message.id, time_entry.id])
        end
      end
    end

    context 'activities in a subproject' do
      let(:subproject) do
        create(:project, parent: project).tap do
          project.reload
        end
      end
      let(:subproject_news) { create(:news, project: subproject) }
      let(:subproject_member) do
        create(:member,
               user: user,
               project: subproject,
               roles: [create(:role, permissions: permissions)])
      end

      let!(:activities) { [news, subproject_news] }

      context 'if including subprojects' do
        before do
          subproject_member
        end

        let(:options) { { project: project, with_subprojects: 1 } }

        it 'finds events in the subproject' do
          expect(subject.map(&:journable_id))
            .to match_array(activities.map(&:id))
        end
      end

      context 'if the subproject has activity disabled' do
        before do
          subproject.enabled_module_names = subproject.enabled_module_names - ['activity']
        end

        it 'lacks events from subproject' do
          expect(subject.map(&:journable_id))
            .to match_array [news.id]
        end
      end

      context 'if lacking permissions for the subproject' do
        let(:options) { { project: project, with_subprojects: 1 } }

        it 'lacks events from subproject' do
          expect(subject.map(&:journable_id))
            .to match_array [news.id]
        end
      end

      context 'if excluding subprojects' do
        before do
          subproject_member
        end

        let(:options) { { project: project } }

        it 'lacks events from subproject' do
          expect(subject.map(&:journable_id))
            .to match_array [news.id]
        end
      end
    end

    context 'activities of a user' do
      let(:options) { { author: user } }
      let!(:activities) do
        # Login to have all the journals created as the user
        login_as(user)
        [work_package, message, news, time_entry, changeset, wiki_page.content]
      end

      it 'finds events of all type' do
        expect(subject.map(&:journable_id))
          .to match_array(activities.map(&:id))
      end

      context 'for a different user' do
        let(:other_user) { create(:user) }
        let(:options) { { author: other_user } }

        it 'does not return the events made by the non queried for user' do
          expect(subject.map(&:journable_id))
            .to be_empty
        end
      end

      context 'if project has activity disabled' do
        before do
          project.enabled_module_names = project.enabled_module_names - ['activity']
        end

        it 'finds no events' do
          expect(subject.map(&:journable_id))
            .to be_empty
        end
      end

      context 'if lacking permissions' do
        let(:permissions) { %i[] }

        it 'finds only events for which permissions are present' do
          # news and message only requires the user to be member
          expect(subject.map(&:journable_id))
            .to match_array([message.id, news.id])
        end
      end

      context 'if restricting the scope' do
        before do
          options[:scope] = %w(time_entries messages)
        end

        it 'finds only events matching the scope' do
          expect(subject.map(&:journable_id))
            .to match_array([message.id, time_entry.id])
        end
      end
    end
  end
end
