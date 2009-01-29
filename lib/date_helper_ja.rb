#
# DateHelperJa
#
# Japanizes ActionView::Helpers::DateHelper.
#
# Released under the MIT license
# Eiji Sakai <eiji.sakai@softculture.com>
# http://d.hatena.ne.jp/elm200/
#
module ActionView
  module Helpers
    class DateTimeSelector
      def initialize_with_jp_time_unit(datetime, options = {}, html_options = {})
        options.update(:use_month_numbers => true) if options[:use_jp_month] != false
        @options      = options.dup
        @html_options = html_options.dup
        @datetime     = datetime
      end
      alias_method_chain :initialize, :jp_time_unit

      private
        def build_options_and_select_with_jp_time_unit(type, selected, options = {})
          if @options[:use_era_name] == true and type == :year
            build_select(type, build_era_name_options(selected, options))
          else
            build_select(type, build_options(selected, options))
          end
        end
        alias_method_chain :build_options_and_select, :jp_time_unit

        # Build select option html from date value and options
        #  build_options(15, :start => 1, :end => 31)
        #  => "<option value="1">1</option>
        #      <option value=\"2\">2</option>
        #      <option value=\"3\">3</option>..."
        def build_era_name_options(selected, options = {})
          start         = options.delete(:start) || 0
          stop          = options.delete(:end) || 59
          step          = options.delete(:step) || 1
          leading_zeros = options.delete(:leading_zeros).nil? ? true : false

          select_options = []
          start.step(stop, step) do |i|
            value = leading_zeros ? sprintf("%02d", i) : i
            tag_options = { :value => value }
            tag_options[:selected] = "selected" if selected == i
            select_options << content_tag(:option, year_with_era_name(value), tag_options)
          end
          select_options.join("\n") + "\n"
        end

        # def year_with_era_name(year)
        #   if year < 1989
        #     "昭和#{year - 1925}年"
        #   elsif year == 1989
        #     "昭和64年/平成元年"
        #   else
        #     "平成#{year - 1988}年"
        #   end
        # end

        def year_with_era_name(year)
          if year < 1868
            "--"
          elsif year < 1912
            "M#{year - 1867}"
          elsif year == 1912
            "M45/T1"
          elsif year < 1926
            "T#{year - 1911}"
          elsif year == 1926
            "T15/S1"
          elsif year < 1989
            "S#{year - 1925}"
          elsif year == 1989
            "S64/H1"
          else
            "H#{year - 1988}"
          end
        end

        # Builds select tag from date type and html select options
        #  build_select(:month, "<option value="1">January</option>...")
        #  => "<select id="post_written_on_2i" name="post[written_on(2i)]">
        #        <option value="1">January</option>...
        #      </select>"
        def build_select_with_jp_time_unit(type, select_options_as_html)
          select_options = {
            :id => input_id_from_type(type),
            :name => input_name_from_type(type)
          }.merge(@html_options)
          select_options.merge!(:disabled => 'disabled') if @options[:disabled]

          select_html = "\n"
          select_html << content_tag(:option, '', :value => '') + "\n" if @options[:include_blank]
          select_html << select_options_as_html.to_s

          content_tag(:select, select_html, select_options) + time_unit(type).to_s + "\n"
        end
        alias_method_chain :build_select, :jp_time_unit

        def separator_with_jp_time_unit(type)
          case type
            when :month, :day
              @options[:date_separator]
            when :hour
              (@options[:discard_year] && @options[:discard_day]) ? "" : (@options[:use_jp_hour] == false ? @options[:datetime_separator] : " ")
            when :minute
              @options[:use_jp_hour] == false ? @options[:time_separator] : ""
            when :second
              @options[:include_seconds] ? (@options[:use_jp_minute] == false ? @options[:time_separator] : "") : ""
          end
        end
        alias_method_chain :separator, :jp_time_unit

        def time_unit(type)
          case type
#            when :year then "年" if @options[:use_era_name] != true
            when :year then @options[:use_jp_year] != false ? '年' : ''
            when :month then @options[:use_jp_month] != false ? '月' : ''
            when :day then @options[:use_jp_day] != false ? '日' : ''
            when :hour then @options[:use_jp_hour] != false ? '時' : ''
            when :minute then @options[:use_jp_minute] != false ? '分' : ''
            when :second then @options[:use_jp_second] != false ? '秒' : ''
          end
        end
    end
  end
end
