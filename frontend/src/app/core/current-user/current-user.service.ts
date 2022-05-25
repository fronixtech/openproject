// -- copyright
// OpenProject is an open source project management software.
// Copyright (C) 2012-2022 the OpenProject GmbH
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License version 3.
//
// OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
// Copyright (C) 2006-2013 Jean-Philippe Lang
// Copyright (C) 2010-2013 the ChiliProject Team
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
//
// See COPYRIGHT and LICENSE files for more details.
//++

import { Injectable } from '@angular/core';
import {
  distinctUntilChanged,
  map,
  take,
} from 'rxjs/operators';
import { ApiV3Service } from 'core-app/core/apiv3/api-v3.service';
import { CapabilityResource } from 'core-app/features/hal/resources/capability-resource';
import { FilterOperator } from 'core-app/shared/helpers/api-v3/api-v3-filter-builder';
import {
  CurrentUser,
  CurrentUserStore,
} from './current-user.store';
import { CurrentUserQuery } from './current-user.query';
import { getPaginatedResults } from 'core-app/core/apiv3/helpers/get-paginated-results';

@Injectable({ providedIn: 'root' })
export class CurrentUserService {
  constructor(
    private apiV3Service:ApiV3Service,
    private currentUserStore:CurrentUserStore,
    private currentUserQuery:CurrentUserQuery,
  ) {
    this.setupLegacyDataListeners();
  }

  public capabilities$ = this.currentUserQuery.capabilities$;

  public isLoggedIn$ = this.currentUserQuery.isLoggedIn$;

  public user$ = this.currentUserQuery.user$;

  /**
   * Set the current user object
   *
   * This refetches the global and current project capabilities
   */
  public setUser(user:CurrentUser) {
    this.currentUserStore.update((state) => ({
      ...state,
      ...user,
    }));

    this.fetchCapabilities([]);
  }

  /**
   * Fetch all capabilities for certain contexts
   */
  public fetchCapabilities(contexts:string[] = []) {
    this.user$.pipe(take(1)).subscribe((user) => {
      if (!user.id) {
        this.currentUserStore.update((state) => ({
          ...state,
          capabilities: [],
        }));

        return;
      }

      const filters:[string, FilterOperator, string[]][] = [['principal', '=', [user.id]]];
      if (contexts.length) {
        filters.push(['context', '=', contexts.map((context) => (context === 'global' ? 'g' : `p${context}`))]);
      }

      getPaginatedResults<CapabilityResource>(
        (params) => this.apiV3Service.capabilities.list({ ...params, filters }),
      )
        .subscribe((capabilities) => {
          this.currentUserStore.update((state) => ({
            ...state,
            capabilities: [
              ...capabilities,
              ...(state.capabilities || []).filter((cap) => !!capabilities.find((newCap) => newCap.id === cap.id)),
            ],
          }));
        });
    });

    return this.currentUserQuery.capabilities$;
  }

  /**
   * Returns the users' capabilities filtered by context
   */
  public capabilitiesForContext$(contextId:string) {
    return this.capabilities$.pipe(
      map((capabilities) => capabilities.filter((cap) => cap.context.href.endsWith(`/${contextId}`))),
      distinctUntilChanged(),
    );
  }

  /**
   * Returns an Observable<boolean> indicating whether the user has the required capabilities in the provided context.
   */
  public hasCapabilities$(action:string|string[], contextId = 'global') {
    const actions = _.castArray(action);
    return this.capabilitiesForContext$(contextId).pipe(
      map((capabilities) => actions.reduce(
        (acc, contextAction) => acc && !!capabilities.find((cap) => cap.action.href.endsWith(`/api/v3/actions/${contextAction}`)),
        capabilities.length > 0,
      )),
      distinctUntilChanged(),
    );
  }

  /**
   * Returns an Observable<boolean> indicating whether the user has any of the required capabilities in the provided context.
   */
  public hasAnyCapabilityOf$(actions:string|string[], contextId = 'global') {
    const actionsToFilter = _.castArray(actions);
    return this.capabilitiesForContext$(contextId).pipe(
      map((capabilities) => capabilities.reduce(
        (acc, cap) => acc || !!actionsToFilter.find((action) => cap.action.href.endsWith(`/api/v3/actions/${action}`)),
        false,
      )),
      distinctUntilChanged(),
    );
  }

  // Everything below this is deprecated legacy interfacing and should not be used

  private setupLegacyDataListeners() {
    this.currentUserQuery.user$.subscribe((user) => (this._user = user));
    this.currentUserQuery.isLoggedIn$.subscribe((isLoggedIn) => (this._isLoggedIn = isLoggedIn));
  }

  private _isLoggedIn = false;

  /** @deprecated Use the store mechanism `currentUserQuery.isLoggedIn$` */
  public get isLoggedIn() {
    return this._isLoggedIn;
  }

  private _user:CurrentUser = {
    id: null,
    name: null,
    mail: null,
  };

  /** @deprecated Use the store mechanism `currentUserQuery.user$` */
  public get userId() {
    return this._user.id || '';
  }

  /** @deprecated Use the store mechanism `currentUserQuery.user$` */
  public get name() {
    return this._user.name || '';
  }

  /** @deprecated Use the store mechanism `currentUserQuery.user$` */
  public get mail() {
    return this._user.mail || '';
  }

  /** @deprecated Use the store mechanism `currentUserQuery.user$` */
  public get href() {
    return `/api/v3/users/${this.userId}`;
  }

  /** @deprecated Use `I18nService.locale` instead */
  public get language() {
    return I18n.locale || 'en';
  }
}
