require 'thread'
class Athlete
	def initialize(k)
		@chipID=k
		@startNum=k
		@speed_v=0
		@position=0
		@measurePoint=0
		@runTime=0
	end
	
	def getChipID
		@chipID
	end
	
	def getStartNum
		@startNUm
	end
	
	def getSpeed
		@speed_v
	end
	def getPosition
		@position
	end
	
	def getMeasurePoint
		@measurePoint
	end
	
	def getRunTime
		@runTime
	end
	
	def setChipID(chip)
		@chipID=chip
	end
	
	def setStartNum(nr)
		@startNum=nr
	end
	
	def setSpeed(speed)
		@speed_v=speed
	end
	
	def setPosition(x)
		@position=x
	end
	
	def setMeasurePoint(p)
		@measurePoint+=p
	end
	
	def setRunTime(t)
		@runTime+=t
	end
end


class Wksimu
  START_CANAL=500   #100-500 Meter
  STARTER =100
  TMAX=300
  DV_MAX = 1
  WETTKAMPF_DAUER=1200 #s =20 Min
  
  def initialize
   @t=0
  @dt = 5
	
	@athlete_all =Hash.new
	#@measurePointList =Hash.new
	@measurePointList ={0=>-1,1=>0, 2=>5000, 3=>10000, 4=>15000, 5=>20000, 6=>21000.1, 7=>25000, 8=>30000, 9=>35000, 10=>40000}
	STARTER.times do |k|
		tmp=Athlete.new(k)
		tmp.setPosition(Random.new.rand(-START_CANAL..0))
		tmp.setChipID(k)
		tmp.setStartNum(k)
		tmp.setSpeed(Random.new.rand(8..18)/3.6)
		@athlete_all[k]=tmp
	end
  end
  
  def refresh_x
    STARTER.times do |k|
		athlete=@athlete_all[k]
		@athlete_all[k].setPosition(athlete.getPosition+athlete.getSpeed*@dt)
    end
    puts "---------------"
  end
  
  #Bestimmt die aktuelle Messpunkte für die Athleten
  def refreshAthleteMeasurePoint()
	 @athlete_all.each {|k,v|
		 puts "in der schleife"
		puts "Position  #{v.getPosition}"
		if v.getPosition >= @measurePointList[v.getMeasurePoint]
			v.setMeasurePoint(1)
			puts "geandert"
		end
	}
  end
  #Geschwindigkeit aktualisieren
  def refresh_v
   STARTER.times do|k|
     tmp=@athlete_all[k]
	 @athlete_all[k].setSpeed(tmp.getSpeed+change_speed_v1)
	end
  end
  
  #Variante 1: v variiert in jeder Zeitscheibe um Zufallswert
  def change_speed_v1
   DV_MAX * (2 * rand-1)
  end
  
  #Variante 2: v erst konstant, dann immer schneller fallend
  def change_speed_v2
	
  end
  
  #Aktualisiert die Zeitscheibe
  def time_slice_refresh
	@t+=@dt
  end
  
  def interval_measure(xalt)
	@athlete_all.each {|k,v|
		if (xalt <= v.getMeasurePoint && v.getPosition > v.getMeasurePoint)
			v.setRunTime(athlete.getRunTime + (v.getMeasurePoint - xalt)/v.getSpeed)
			puts v.getChipID +" " +v.getRunTime + " " +v.getMeasurePoint
		elsif
			puts v.getChipID +" ist im Ziel!" + v.getRunTime
			k.pop
		end
	}
		
  end
end

c= Wksimu.new()

1200.times do
	c.refresh_x				#Aktualisierung der Position
	c.refreshAthleteMeasurePoint
	c.refresh_v				#Aktualisierung der Geschwindigkeit
	c.time_slice_refresh			#Aktualiserung der Zeitscheibe
	sleep (5)
end


