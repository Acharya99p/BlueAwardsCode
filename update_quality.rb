require 'award'

NORMAL_ITEM = 'NORMAL ITEM'
BLUE_FIRST = 'Blue First'
BLUE_COMPARE = 'Blue Compare'
BLUE_PLUS = 'Blue Distinction Plus'
BLUE_STAR = 'Blue Star'

AWARDS = [BLUE_FIRST, BLUE_COMPARE, BLUE_PLUS, BLUE_STAR]

class Quality
  def self.update_quality(awards)
    awards.each do |award|
      if [NORMAL_ITEM, BLUE_STAR].include? award.name
        send(transform_name(award.name), award)
      else
        if award.quality < 50
          award.quality += 1
          if award.name == BLUE_COMPARE
            award.quality += 1 if award.expires_in < 11
            award.quality += 1 if award.expires_in < 6
          end
        end
      end
      
      award.expires_in -= 1 if(award.name != BLUE_PLUS)

      send(transform_name(award.name), award) if award.expires_in < 0
    end
  end

  def self.blue_star(award)
    award.quality -= 2 if award.quality > 0
  end

  def self.blue_compare(award)
    award.quality -= award.quality
  end

  def self.blue_first(award)
    award.quality += 1 if award.quality < 50 
  end

  def self.blue_distinction_plus(award)
  end

  def self.normal_item(award)
    award.quality -= 1 if award.quality > 0
  end

  def self.transform_name(method)
    method.downcase.gsub(' ', '_')
  end
end
