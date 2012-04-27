class WantedToon < ActiveRecord::Base
  has_many :wt_ships, :order => :created_at
  attr_accessible :bounty, :character_id, :name
  
  def self.make_wanted_toon(name,characterid,bounty)
    wanted_toon = find_or_create_by_character_id(characterid)
    wanted_toon.name ||= name
    wanted_toon.bounty ? wanted_toon.bounty += bounty : wanted_toon.bounty = bounty
    if wanted_toon.save!
      return true
    else
      #create sendmail to admin with error and character information.
      return false
    end
  end
  
  #update_records => [[URI, SHIP TYPE, SYSTEM, TIME, ISK DESTROYED, ISK DROPPED, VERIFIED(BOOL)]]
  def update_toon_create_ship_record(update_records)
    update_records.each do |r|
      if WtShip.find_by_eve_time_date(r[3]) #unless there is an exact time match for a record, create a new record
	return false
      else
	wt_ships.create!(:lossurl => r[0], :ship_type => r[1], :solar_system => r[2], :eve_time_date => r[3], 
			:isk_destroyed => r[4], :isk_dropped => r[5], :payout_amt => ((r[4] - r[5]) * 0.65)
			) # Payout, ttl destroyed isk - isk dropped * 65%
      end
    end
  end
end
