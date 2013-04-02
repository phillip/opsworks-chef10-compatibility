#
# Author:: Adam Jacob (<adam@opscode.com>)
# Author:: Christopher Walters (<cw@opscode.com>)
# Copyright:: Copyright (c) 2008, 2009 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/provider'
require File.dirname(__FILE__) + '/mixin/language'
require File.dirname(__FILE__) + '/mixin/why_run'

class Chef::Provider
  include Chef::Mixin::WhyRun
  include Chef::Mixin::Language
  
  def run_action(action=nil)
    @action = action unless action.nil?
    new_resource.updated_by_last_action(true) unless converge_actions.empty?
  end
  
  protected

  def converge_actions
    @converge_actions ||= ConvergeActions.new(@new_resource, run_context, @action)
  end

  def converge_by(descriptions, &block)
    converge_actions.add_action(descriptions, &block)
  end
end