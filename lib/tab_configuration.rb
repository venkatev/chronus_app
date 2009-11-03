require File.join(RAILS_ROOT, 'config', 'tab_constants')

module TabConfiguration
  def self.included(controller)
    controller.send :include, InstanceMethods
  end

  # Represents a tab in the application.
  class Tab
    attr_accessor :label
    attr_accessor :url
    attr_accessor :active

    def initialize(init_label, init_url, init_active)
      @label = init_label
      @url = init_url
      @active = init_active
    end
  end

  module InstanceMethods
    # <code>Tab</code>s in the order of addition
    attr_accessor :ordered_tabs

    # <code>Tab</code>s indexed by tab label
    attr_accessor :all_tabs
  end

  # Adds the tab for the given configuration.
  #
  # ==== Params
  # label       ::  <code>TabConfiguration::Tab</code> to be added
  # url         ::  url that the tab should link to
  # active      ::  true if the tab should be marked active.
  #
  def add_tab(label, url, active)
    tab_entry = Tab.new(label, url, active)
    self.all_tabs ||= {}
    self.ordered_tabs ||= []
    self.all_tabs[label] = tab_entry
    self.ordered_tabs << tab_entry
  end

  # Iterate until we find the first match, assign the selected tab and break
  # out of the loop.
  def compute_active_tab
    selected_tab = default_tab
    self.ordered_tabs.each do |all_tabs|
      (selected_tab = all_tabs) and break if all_tabs.active
    end
    activate_tab(selected_tab)
  end

  # Marks the tab corresponding to the given <i>given_all_tabs</i> as active
  # and also setting all others inactive.
  #
  def activate_tab(given_all_tabs)
    self.ordered_tabs.each do |tab|
      tab.active = (tab == given_all_tabs)
    end
  end
end
