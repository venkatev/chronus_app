module ApplicationHelper
  #-----------------------------------------------------------------------------
  # LAYOUT RELATED
  #-----------------------------------------------------------------------------

  # Sets the title string
  def title(str)
    content_for :title, str
  end

  # Pane with given content
  def pane(header_text, options = {}, &block)
    pane_content = content_tag(:div, header_text, :class => 'pane_header')
    pane_content += content_tag(:div, capture(&block), :class => 'pane_content clearfix')

    # Show see all link if either entries count is not given, or the current
    # count is lesser than the maximum entries.
    #
    show_see_all = (!(options[:total_entries] && options[:max_entries]) ||
        (options[:total_entries] > options[:max_entries])) && options[:see_all]

    if show_see_all || options[:pane_action]
      pane_content += content_tag(:div, :class => 'pane_footer clearfix') do
        footer_content = ''

        # See all link
        if show_see_all
          footer_content += content_tag(:div, options[:see_all], :class => 'pane_see_all')
        end

        # Action link
        if options[:pane_action]
          footer_content += content_tag(:div, options[:pane_action], :class => 'pane_action')
        end

        footer_content
      end
    end

    pane_content = content_tag(:div, pane_content, :class => 'pane')
    concat pane_content
  end

  # renders the breadcrumbs bar
  # Render the crumbs if there are > 1 crumbs
  # If mode == :force, renders the crumbs even if there only one crumb
  def breadcrumbs_bar(mode = nil)
    content_tag("div", :id => 'breadcrumbs') do
      render_crumbs :seperator => '<span>&nbsp;&rsaquo;&nbsp;</span>'
    end if (mode == :force || crumbs.size > 1) && !@no_crumbs
  end

  # Action container with dummy label for left aligning with rest of the form
  def action_set(options = {}, &block)
    action_code = capture(&block)

    required_text = ""

    # Required fields information.
    if options[:fields_required]
      required_text = (options[:fields_required] == :all) ?
        "All fields are required" : "Fields marked * are required"

      required_text = content_tag(:div, required_text,:class => "fields_required")
    end

    loader_code = options[:loader] ? image_tag(
      "ajax-loader.gif", :id => options[:loader],
      :style => "display: none; margin-left: 7px; height: 25px;") : ""

    indentation_code = ""
    indentation_code = content_tag(:label) unless options[:dont_indent]
    action_code = content_tag(:div, :class => 'action_and_info') do
      required_text + action_code + loader_code
    end

    action_code = content_tag(:div, :class => 'action_set clearfix') do
      indentation_code + action_code
    end

    concat(action_code)
  end

  # Renders cancel link defaulting to referrer.
  # If use_default is true, link to that unconditionally.
  def cancel_link(back_url = nil, options = {})
    url = back_url
    url = back_url_or_default(
      back_url || program_root_path) unless options[:use_default]

    content_tag(:span, "or&nbsp;", :class => 'or_cancel') +
      link_to('cancel', url, :class => 'cancel')
  end

  # Action container with dummy label for left aligning with rest of the form
  def formatted_form_error(f, options = {}, &block)
    # There can be error only if there's an object and its faulty
    return unless f.object
    return f.error_messages(options) if f.object.errors.empty?
    content_tag(:label, '') + f.error_messages(options)
  end

  # Renders the given user's picture if present, or default picture otherwise.
  def user_picture(user, options = {})
    # When rendering user picture for a group, linking to group page instead of
    # profile.
    item_link = options[:item_link]
    item_link ||= options[:group] ? group_path(options[:group]) : user_path(user)

    # Default to small picture.
    size_sym = options[:size] || :small
    box_content = ""
    content_tag(:div, :class => "member_box #{size_sym}") do
      box_content = link_to_unless(
        user.admin?, image_tag(user.picture_url(size_sym),
          :alt => user.name, :title => user.name), item_link)

      unless options[:no_name]
        box_content += content_tag(:div, link_to(user.name, item_link), :class => 'member_name')
      end

      box_content
    end
  end

  # Renders pagination links for the given collection
  def pagination_bar(collection, options = {})
    return if collection.empty? && !options[:empty_collection]
    entry_name = options[:entry_name]
    content_tag(:div,
      page_entries_info(collection, :entry_name => entry_name),
      :class => "cur_page_info") +
      (will_paginate(collection, {
          :inner_window => 1, :outer_window => 1}.merge(options))||'')
  end

  # Renders select options with required logic for sorting
  #
  # NOTE: This helper renders sorting options code only for non-AJAX sorting.
  #
  # ==== Params
  # page_url  :: url to load with options on change of sorting choice
  # cur_field :: field on which current sorting is done
  # cur_order :: whether the current sorting is ascending or descending
  # sort_info :: array containing an entry for each sort choicem with the
  #             following keys.
  #             :label - the label to show, say, 'Date'
  #             :field - the field to sort by
  #             :order - asc or desc sorting
  #
  def sort_options(page_url, cur_field, cur_order, sort_info, options = {})
    sort_select = (content_tag(:select, :onchange => "submitSortForm(this.value)") do
        options_content = ""
        sort_info.each do |_info|
          opts = {}
          opts[:selected] = "selected" if cur_field.to_s == _info[:field].to_s &&
            cur_order.to_s == _info[:order].to_s

          # Onclick of the option sets the current field, order and submits the
          # form
          opts[:value] = "#{_info[:field]},#{_info[:order]}"

          options_content << content_tag(:option, _info[:label], opts)
        end
        options_content
      end)

    sort_form = (content_tag(:form, :action => page_url, :method => :get,
        :id => 'sort_form', :style => 'display: none;') do
        fields_content = hidden_field_tag(:sort, :name, :id => 'sort_field')
        fields_content += hidden_field_tag(:order, :asc, :id => 'sort_order')

        (options[:url_params] || {}).each do |key, value|
          fields_content += hidden_field_tag(key, value)
        end

        fields_content
      end)

    content_tag(:div, :class => 'sorting') do
      "&nbsp;Sort by &nbsp;" + sort_select + sort_form
    end
  end

  # Returns meeting time string for the given profile
  # Yields the given block or content inside quotes.
  #
  def quotes(content_or_opts_with_block = nil, &block)
    if block_given?
      content_tag(:blockquote, :class => 'quotes') do
        capture(&block)
      end
    else
      content_tag(:blockquote, :class => 'quotes') do
        content_or_opts_with_block
      end
    end
  end

  # Generates a pane with header with the given block as the content that can
  # be expanded or collpased by clicking on the header.
  #
  # A right or downward arrow in the header will indicates the current expansion
  # state of the pane.
  #
  # ==== Params
  # header_label   : the label to show on the pane header. The pane and content
  #                  DOM ids will be generated out of this label. If the label
  #                  is 'India Is Great', the header id will be
  #                  'india_is_great_header' and the content container id will
  #                  be 'india_is_great_content'
  # other_sections : an *Array* of other sections names (labels) that need to be
  #                  expanded or collapsed when this pane's state is changed.
  #                  Default => []
  #
  def collapsible_content(header_label, other_sections = [], collapsed = true, options = {}, &block)
    # Returns the DOM element id prefix to be used for the element with the
    # given label
    id_prefix_from_label = Proc.new do |label|
      label.to_s.capitalize.downcase.underscore.gsub(/\s/, '_') + '_'
    end

    # 'India Is Great' => 'india_is_great'
    id_prefix = id_prefix_from_label.call(header_label)
    header_id = id_prefix + 'header'
    content_id = id_prefix + 'content'

    other_section_array = (other_sections).collect { |sec_label|
      "'#{id_prefix_from_label.call(sec_label)}'"
    }.join(',')

    # Clickable section header
    header_code =
      content_tag('div', :class => 'exp_collapse_header') do
      content_tag(:div, :class => collapsed ? 'collapsed' : 'expanded', :id => header_id,
        :onclick => "ChronusEffect.ExpandSection('#{id_prefix}', [#{other_section_array}])") do
        header_label
      end
    end

    pane_content = content_tag(:div, capture(&block), :class => 'content',
      :style => collapsed ? 'display: none' : '', :id => content_id)

    concat(header_code + (options[:pane_footer] || "") + pane_content)
    filter_options(title, page_url, current_field_value, filter_info, options)
  end

  # Renders the listing view filters.
  #
  # ==== Params
  # filter_info         ::  an <code>Array</code> where each entry is a
  #                         <code>Hash</code> providing the options for a filter
  #                         entry.
  #                         ---
  #                         value ::  the filter param to be used
  #                         label ::  the display label for the filter
  #
  # page_url            ::  the base page url on top of which to apply the filters.
  #
  # current_field_value ::  currently applied page filter.
  #
  # options             ::  other extra options for the filter elements.
  #
  # ==== Examples
  #
  #   filter_info = [
  #     {:value => "all", :label => "All"},
  #     {:value => "available", :label => "Available"}], it is name value pair
  #
  #   filter_options("Show ",
  #     users_path, @current_field_value, filter_info, options}
  #
  #   options = {
  #     :url_params => {}
  #   }
  #
  def filter_options(title, page_url, current_field_value, filter_info, options = {})
    filter_select = (
      content_tag(:select, :onchange => "submitFilterForm(this.value)") do
        options_content = ""
        filter_info.each do |_info|
          opts = {}
          opts[:selected] = "selected" if current_field_value && (current_field_value.to_s == _info[:value].to_s)
          opts[:value] = _info[:value]

          options_content << content_tag(:option, _info[:label], opts)
        end
        options_content
      end
    )
    filter_form = (
      content_tag(:form, :action => page_url, :method => :get, :id => 'filter_form', :style => 'display: none;') do
        fields_content = hidden_field_tag(:filter, "", :id => 'filter_name')

        (options[:url_params] || {}).each do |key, value|
          fields_content += hidden_field_tag(key, value)
        end
        fields_content
      end
    )
    content_tag(:div, :class => 'filtering') do
      title + filter_select + filter_form
    end
  end

  # Renders a JS tooltip (span + script).
  #
  # ==== Params
  # node_id   ::  The id of the div for which the tooltip is to be rendered
  # tip_text  ::  The tooltip text.
  #
  def tooltip(node_id, tip_text, relative = false)
    tooltip_node_id = "#{node_id}_ttip"
    use_relative = relative ? 'true' : 'false'
    content_tag(:span, tip_text, :id => tooltip_node_id, :class => "help_tip", :style=> "display:none;") +
      content_tag(:script) { "new Tooltip('#{node_id}', '#{tooltip_node_id}', #{use_relative});" }
  end

  #-----------------------------------------------------------------------------
  # UTILITIES
  #-----------------------------------------------------------------------------

  # Truncates the given text to <i>length</i> characters if the text is longer
  # than that. The default truncation string is '...' <i>truncate_string</i>
  #
  def word_truncate_with_status(text, length = 40, truncate_string = "... ")
    return if text.nil?
    l = length - truncate_string.length
    if text.length > length
      return text[/\A.{#{l}}\w*\;?/m][/.*[\w\;]/m] + truncate_string, true
    else
      return text, false
    end
  end

  # Returns <i>text</i> if not blank, and <i>default value</i> othewise.
  def default_if_blank(text, default_value)
    text.blank? ? default_value : text
  end

  # Returns the time string in words
  #
  # formatted_time_in_words(t)                    => August 26, 2008 at 3:30 A.M.
  # formatted_time_in_words(t1)                   => 2 hours ago
  # formatted_time_in_words(t1, :no_ago => true)  => on July 26, 2008 at 3:30 A.M.
  # formatted_time_in_words(t1, :no_time => true) => July 26, 2008
  # formatted_time_in_words(t1, :no_date => true) => July, 2008
  #
  # ==== Params
  #
  # absolute  - return words representing absolute time, without using any of
  #             'ago', 'on' or 'at'.
  # no_time   - skip '...at time' at the end.
  #
  def formatted_time_in_words(given_time, options = {})
    return "" if given_time.nil?
    given_time = given_time.getlocal

    # If the time is within last 24 hours, show as "...ago" string.
    if (1.day.ago..Time.now) === given_time && !options[:no_ago]
      time_ago_in_words(given_time) + " ago"
    else
      format_str = "%B"
      format_str << " %d," unless options[:no_date]
      format_str << " %Y"
      format_str << " at %I:%M %p" unless options[:no_time]
      given_time.strftime(format_str)
    end
  end

  # Displays formatted string representation of the given date object.
  def formatted_date_in_words(date_obj, options = {})
    return "" if date_obj.nil?
    formatted_time_in_words(date_obj.to_time,
      options.merge(:no_time => true, :absolute => true))
  end

  def secure_protocol
    SSL_ALLOWED ? 'https' : 'http'
  end
end
