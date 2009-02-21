# -*- coding: utf-8 -*-
#
# DateHelperJa
#
# Japanizes ActionView::Helpers::DateHelper.
# This is code for Ruby on Rails 2.1.2
#
# Released under the MIT license
# Eiji Sakai <eiji.sakai@softculture.com>
# http://d.hatena.ne.jp/elm200
#
# Hideki Hayashi <hideki.gml@gmail.com>
# http://d.hatena.ne.jp/milk1000cc
#
module ActionView
  module Helpers
    module DateHelper
      #
      # 2つの Time オブジェクト・Date オブジェクトまたは整数(秒数）のだいたいの間隔を報告する。
      # 1分29秒以内の詳細な近似値が必要なら、<tt>include_secondes</tt> を true にすること。
      # 間隔は次の表に基づいて報告される：
      #
      # 0 <-> 29 秒                                                               # => 1分以内
      # 30 秒 <-> 1 分 29 秒                                                      # => 1分
      # 1 分 30 秒 <-> 44 分 29 秒                                                # => [2..44]分
      # 44 分  30 秒 <-> 89 分, 29 秒                                             # => 約1時間
      # 89 分 29 秒 <-> 23 時間 59 分 29 秒                                       # => 約[2..24]時間
      # 23 時間 59 分 29 秒 <-> 47 時間 59 分 29 秒                               # => 1日
      # 47 時間 59 分 29 秒 <-> 29 日 23 時間 59 分 29 秒                         # => [2..29]日
      # 29 日 23 時間 59 分 30 秒 <-> 59 日 23 時間 59 分 29 秒                   # => 約1ヶ月
      # 59 日 23 時間 59 分 30 秒 <-> 1 年 マイナス 31 秒                         # => [2..12]ヶ月
      # 1 年 マイナス 30 秒 <-> 2 年 マイナス 31 秒                               # => 約1年
      # 2 年 マイナス 30 秒 <-> time または date の最大値                         # => [2..X]年以上
      #
      # include_seconds = true で間隔 < 1 分 29 秒のとき
      # 0-4   秒      # => 5秒以内
      # 5-9   秒      # => 10秒以内
      # 10-19 秒      # => 20秒以内
      # 20-39 秒      # => 30秒前後
      # 40-59 秒      # => 1分以内
      # 60-89 秒      # => 1分
      #
      # Examples:
      #
      #   from_time = Time.now
      #   distance_of_time_in_words(from_time, from_time + 50.minutes) # => 約1時間
      #   distance_of_time_in_words(from_time, from_time + 15.seconds) # => 1分以内
      #   distance_of_time_in_words(from_time, from_time + 15.seconds, true) # => 20秒以内
      #
      # 注意： Rails は1年を365.25日として計算する。
      def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false)
        from_time = from_time.to_time if from_time.respond_to?(:to_time)
        to_time = to_time.to_time if to_time.respond_to?(:to_time)
        distance_in_minutes = (((to_time - from_time).abs)/60).round
        distance_in_seconds = ((to_time - from_time).abs).round

        case distance_in_minutes
          when 0..1
            return (distance_in_minutes == 0) ? '1分以内' : '1分' unless include_seconds
            case distance_in_seconds
              when 0..4   then '5秒以内'
              when 5..9   then '10秒以内'
              when 10..19 then '20秒以内'
              when 20..39 then '30秒前後'
              when 40..59 then '1分以内'
              else             '1分'
            end

          when 2..44           then "#{distance_in_minutes}分"
          when 45..89          then '約1時間'
          when 90..1439        then "約#{(distance_in_minutes.to_f / 60.0).round}時間"
          when 1440..2879      then '1日'
          when 2880..43199     then "#{(distance_in_minutes / 1440).round}日"
          when 43200..86399    then '約1ヶ月'
          when 86400..525959   then "#{(distance_in_minutes / 43200).round}ヶ月"
          when 525960..1051919 then '約1年'
          else                      "#{(distance_in_minutes / 525960).round}年以上"
        end
      end

      def select_second_with_jp_time_unit(datetime, options = {}, html_options = {})
        select_second_without_jp_time_unit(datetime, options, html_options).chomp + (options[:use_jp_second] != false && !options[:use_hidden] ? '秒' : '') + "\n"
      end

      def select_minute_with_jp_time_unit(datetime, options = {}, html_options = {})
        select_minute_without_jp_time_unit(datetime, options, html_options).chomp + (options[:use_jp_minute] != false && !options[:use_hidden] ? '分' : '') + "\n"
      end

      def select_hour_with_jp_time_unit(datetime, options = {}, html_options = {})
        select_hour_without_jp_time_unit(datetime, options, html_options).chomp + (options[:use_jp_hour] != false && !options[:use_hidden] ? '時' : '') + "\n"
      end

      def select_day_with_jp_time_unit(date, options = {}, html_options = {})
        select_day_without_jp_time_unit(date, options, html_options).chomp + (options[:use_jp_day] != false && !options[:use_hidden] ? '日' : '') + "\n"
      end

      def select_month_with_jp_time_unit(date, options = {}, html_options = {})
        options.update(:use_month_numbers => true) if options[:use_jp_month] != false
        select_month_without_jp_time_unit(date, options, html_options).chomp  + (options[:use_jp_month] != false && !options[:use_hidden] ? '月' : '') + "\n"
      end

      def select_year_with_jp_time_unit(date, options = {}, html_options = {})
       # select_year_without_jp_time_unit(date, options, html_options).chomp  + (options[:use_jp_year] != false && !options[:use_hidden] ? '年' : '') + "\n"
        val = date ? (date.kind_of?(Fixnum) ? date : date.year) : ''
        if options[:use_hidden]
          hidden_html(options[:field_name] || 'year', val, options)
        else
          year_options = []
          y = date ? (date.kind_of?(Fixnum) ? (y = (date == 0) ? Date.today.year : date) : date.year) : Date.today.year

          start_year, end_year = (options[:start_year] || y-5), (options[:end_year] || y+5)
          step_val = start_year < end_year ? 1 : -1
          start_year.step(end_year, step_val) do |year|
            year_caption = build_year_caption(year, options)
            year_options << ((val == year) ?
              content_tag(:option, year_caption, :value => year, :selected => "selected") :
              content_tag(:option, year_caption, :value => year)
            )
            year_options << "\n"
          end
          
          era_format = options[:era_format] || :ja_long
          postfix = options[:use_jp_year] == false || (options[:use_era_name] == true &&  era_format ==  :ja_long ) ? '' : '年'

          select_html(options[:field_name] || 'year', year_options.join, options, html_options).chomp + postfix + "\n"
        end

      end
      
      def build_year_caption(year, options)
        if options[:use_era_name] == true 
           build_year_with_era_name(year, options)
        else
           year
        end
      end
      
      def build_year_with_era_name(year, options)
        case options[:era_format]
        when :ja_short
          era_formats = {:M => "明%d", :T => "大%d", :S => "昭%d", :H => "平%d"}
          era_first_years = {:M => '明1', :T => '明45/大1', :S => '大15/昭1', :H => '昭64/平1'}
        when :alphabet
          era_formats = {:M => "M%d", :T => "T%d", :S => "S%d", :H => "H%d"}
          era_first_years = {:M => 'M1', :T => 'M45/T1', :S => 'T15/S1', :H => 'S64/H1'}
        else # when :ja_long or others
          era_formats = {:M => "明治%d年", :T => "大正%d年", :S => "昭和%d年", :H => "平成%d年"}
          era_first_years = {:M => '明治元年', :T => '明45年/大1年', :S => '大15年/昭1年', :H => '昭64年/平1年'}
        end

        if year < 1868
          year
        elsif year == 1868
          era_first_years[:M]
        elsif year < 1912
          era_formats[:M] % (year - 1867)
        elsif year == 1912
          era_first_years[:T]
        elsif year < 1926
          era_formats[:T] % (year - 1911)
        elsif year == 1926
          era_first_years[:S]
        elsif year < 1989
          era_formats[:S] % (year - 1925)
        elsif year == 1989
          era_first_years[:H]
        else
          era_formats[:H] % (year - 1988)
        end
      end      

      alias_method_chain :select_minute, :jp_time_unit
      alias_method_chain :select_hour, :jp_time_unit
      alias_method_chain :select_second, :jp_time_unit
      alias_method_chain :select_day, :jp_time_unit
      alias_method_chain :select_month, :jp_time_unit
      alias_method_chain :select_year, :jp_time_unit
    end

    class InstanceTag
      def date_or_time_select_with_jp_time_unit(options, html_options = {})

        defaults = { :discard_type => true }
        options  = defaults.merge(options)
        datetime = value(object)
        datetime ||= default_time_from_options(options[:default]) unless options[:include_blank]

        position = { :year => 1, :month => 2, :day => 3, :hour => 4, :minute => 5, :second => 6 }

        order = (options[:order] ||= [:year, :month, :day])

        # Discard explicit and implicit by not being included in the :order
        discard = {}
        discard[:year]   = true if options[:discard_year] or !order.include?(:year)
        discard[:month]  = true if options[:discard_month] or !order.include?(:month)
        discard[:day]    = true if options[:discard_day] or discard[:month] or !order.include?(:day)
        discard[:hour]   = true if options[:discard_hour]
        discard[:minute] = true if options[:discard_minute] or discard[:hour]
        discard[:second] = true unless options[:include_seconds] && !discard[:minute]

        if datetime && discard[:day] && !discard[:month]
          datetime = datetime.change(:day => 1)
        end

        # Maintain valid dates by including hidden fields for discarded elements
        [:day, :month, :year].each { |o| order.unshift(o) unless order.include?(o) }
        # Ensure proper ordering of :hour, :minute and :second
        [:hour, :minute, :second].each { |o| order.delete(o); order.push(o) }

        date_or_time_select = ''
        order.reverse.each do |param|
          # Send hidden fields for discarded elements once output has started
          # This ensures AR can reconstruct valid dates using ParseDate
          next if discard[param] && date_or_time_select.empty?

          date_or_time_select.insert(0, self.send("select_#{param}", datetime, options_with_prefix(position[param], options.merge(:use_hidden => discard[param]))))
          date_or_time_select.insert(0,
            case param
             # assumes that the date format comes in the order of year, month, day, hour, minute and second.
              when :hour then (discard[:year] && discard[:day] ? "" : (options[:use_jp_day] == false ? " &mdash; " : " "))
              when :minute then (options[:use_jp_hour] == false ? " : "  : "")
              when :second then options[:include_seconds] ? (options[:use_jp_minute] == false ? " : "  : "") : ""
              else ""
            end)

        end

        date_or_time_select
      end

      alias_method_chain :date_or_time_select, :jp_time_unit
    end
  end
end