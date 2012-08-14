#!/usr/bin/ruby

#  do_seed_database.sh
#  BMD-X
#
#  Created by Steven Fuchs on 3/10/12.
#  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
require 'rubygems'
require 'osx/cocoa'


def safe_or_space( db_val )
    (db_val.match( /\w/ ).nil? ) ? '' : db_val.to_s
end
def safe_or_nbsp( db_val )
    puts db_val
    (db_val.to_s == '&nbsp' ) ? '' : db_val.to_s
end
def process_town_name( db_val )
    puts db_val
    (db_val.to_s == '&nbsp' ) ? '' : db_val.to_s
    db_val.gsub(",", "").gsub( /\(.*\)/, '' ).strip
end

    
    def month_from_quarter( qrtr )
        ans = "01"
        if ( qrtr == "2" )
            ans = "04"
        elsif ( qrtr == "3" )
            ans = "07"
        elsif ( qrtr == "4" )
            ans = "10"
        end
        ans
    end


    require 'hpricot'
    require 'open-uri'

    File.open('bmd_town_dump.txt', 'w') do |f2|
        doc = open("http://www.freebmd.org.uk/district-list.html") { |f| Hpricot(f) }
        doc.search("tr").each do | a_row|
            row_array = a_row.search("td")
            if ( row_array.count == 7 )
                town_name = ""
                start_date = nil
                end_date = nil
                vol_1 = nil
                vol_2 = nil
                vol_3 = nil
                vol_4 = nil
                vol_5 = nil

                unless row_array[0].at('a').nil?
                    town_name   = row_array[0].at('a').inner_text
                else
                    town_name   = row_array[0].inner_text
                end
                
                
                date_arr = row_array[1].inner_text.strip.split("-")
                start_year = ""
                start_qtr = ""
                end_year = ""
                end_qtr = ""

                if ( date_arr.count != 0 )
                    if ( (!date_arr[0].nil?) && (date_arr[0].strip != "") )
                        date_parse = date_arr[0].strip.split("Q")
                        yr_str = "%s-%s-01 12:00:00 +0000" % [ date_parse[0], month_from_quarter(date_parse[1]) ] 
                        start_date = OSX::NSDate.alloc.initWithString( yr_str )
                        start_qtr = date_parse[1]
                        start_year = date_parse[0]
                    end

                    if ( (!date_arr[1].nil?) && (date_arr[1].strip != "") )
                        date_parse = date_arr[1].strip.split("Q")
                        yr_str = "%s-%s-01 12:00:00 +0000" % [ date_parse[0], month_from_quarter(date_parse[1]) ] 
                        end_date = OSX::NSDate.alloc.initWithString( yr_str )
                        end_qtr = date_parse[1]
                        end_year = date_parse[0]
                   end
                end

                vol_1 = row_array[2].inner_text.strip
                vol_2 = row_array[3].inner_text.strip
                vol_3 = row_array[4].inner_text.strip
                vol_4 = row_array[5].inner_text.strip
                vol_5 = row_array[6].inner_text.strip
                
                f2.puts %(#{process_town_name(town_name)},#{safe_or_nbsp(start_qtr)},#{safe_or_nbsp(start_year)},#{safe_or_nbsp(end_qtr)},#{safe_or_nbsp(end_year)},#{safe_or_space(vol_1)},#{safe_or_space(vol_2)},#{safe_or_space(vol_3)},#{safe_or_space(vol_4)},#{safe_or_space(vol_5)} )
            end
        end
    end



