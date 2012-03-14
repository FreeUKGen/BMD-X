#!/usr/bin/ruby

#  do_seed_database.sh
#  BMD-X
#
#  Created by Steven Fuchs on 3/10/12.
#  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
require 'rubygems'
require 'osx/cocoa'

OSX.require_framework 'CoreData'

class CoreDataStore
    def create_entity name, props={}, relationships={}
        entity = OSX::NSEntityDescription.insertNewObjectForEntityForName_inManagedObjectContext(name, context)
        props.each do |k,v|
            entity.setValue_forKey v, k
        end
        relationships.each do |k, objects|
            collection = entity.mutableSetValueForKey(k)
            objects.each {|o| collection.addObject o}
        end

        entity
    end

    def initialize(data_store_path, mom_path)
        @data_store_path = data_store_path
        @mom_path = mom_path
    end

    def context
        @context ||= OSX::NSManagedObjectContext.alloc.init.tap do |context|
            model = OSX::NSManagedObjectModel.alloc.initWithContentsOfURL(OSX::NSURL.fileURLWithPath(@mom_path))
            coordinator = OSX::NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(model)

            result, error = coordinator.addPersistentStoreWithType_configuration_URL_options_error(OSX::NSSQLiteStoreType, nil, OSX::NSURL.fileURLWithPath(@data_store_path), nil)
            if !result
                raise "Add persistent store failed: #{error.description}"
            end
            context.setPersistentStoreCoordinator coordinator
        end
    end

    def save
        res, error = context.save_
        if !res
            raise "Save failed: #{error.description}"
        end
        res
    end
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
    store = CoreDataStore.new('BMDData.sqlite', 'BMDData.momd/BMDData.mom')

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

            if ( date_arr.count != 0 )
                if ( (!date_arr[0].nil?) && (date_arr[0].strip != "") )
                    date_parse = date_arr[0].strip.split("Q")
                    yr_str = "%s-%s-01 12:00:00 +0000" % [ date_parse[0], month_from_quarter(date_parse[1]) ] 
                    start_date = OSX::NSDate.alloc.initWithString( yr_str )
                end

                if ( (!date_arr[1].nil?) && (date_arr[1].strip != "") )
                    date_parse = date_arr[1].strip.split("Q")
                    yr_str = "%s-%s-01 12:00:00 +0000" % [ date_parse[0], month_from_quarter(date_parse[1]) ] 
                    end_date = OSX::NSDate.alloc.initWithString( yr_str )
                end
            end

            vol_1 = row_array[2].inner_text.strip
            vol_2 = row_array[3].inner_text.strip
            vol_3 = row_array[4].inner_text.strip
            vol_4 = row_array[5].inner_text.strip
            vol_5 = row_array[6].inner_text.strip

puts vol_1.inspect
puts row_array[2].inner_text.inspect

ans_hash = {'name' => town_name, 'start' => start_date, 'end' => end_date, 'volume_1' => vol_1, 'volume_2' => vol_2, 'volume_3' => vol_3, 'volume_4' => vol_4, 'volume_5' => vol_5}

            puts ans_hash.inspect
            dist = store.create_entity 'District', ans_hash
        end
    end

    store.save




