// -- copyright
// OpenProject is an open source project management software.
// Copyright (C) 2012-2020 the OpenProject GmbH
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
// ++

// This file is generated by Rails using the rake task
// rake openproject:plugins:register_frontend

import {NgModule} from "@angular/core";
import {PluginModule as Budgets} from './linked/budgets/main';
import {PluginModule as Costs} from './linked/costs/main';
import {PluginModule as OpenprojectAvatars} from './linked/openproject-avatars/main';
import {PluginModule as OpenprojectDocuments} from './linked/openproject-documents/main';
import {PluginModule as OpenprojectGithubIntegration} from './linked/openproject-github_integration/main';

@NgModule({
    imports: [
        Budgets,
        Costs,
        OpenprojectAvatars,
        OpenprojectDocuments,
        OpenprojectGithubIntegration,
    ],
})
export class LinkedPluginsModule { }



