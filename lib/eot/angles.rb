# angles.rb

require 'celes'

class Eot
  include Math
  # From angles.rb:    
  # Apparent solar longitude = true longitude - aberation   
  def al_Sun()    
    #Celes.anp(tl_Sun() - 0.00569 * D2R - 0.00478 * D2R * sin(omega()))
    Celes.anp(al(@ma, @ta, Celes.faom03(@ta)))
  end 
  alias_method  :apparent_longitude, :al_Sun 
  alias_method  :alsun, :al_Sun
  
  # From angles.rb:   
  # delta epsilon
  # component of equation of equinox 
  def angle_delta_epsilon()    
    Celes.nut06a(@ajd, 0)[ 1 ]
  end
   alias_method  :delta_epsilon, :angle_delta_epsilon
  
  # From angles.rb:   
  # one time component to total equation of time
  def angle_delta_oblique()           
    #al(@ma, @ta, Celes.faom03(@ta)) - ra_Sun()
    al_Sun() - ra_Sun()        
  end
  alias_method :delta_t_ecliptic, :angle_delta_oblique
  alias_method :delta_oblique, :angle_delta_oblique
  
  # From angles.rb:    
  # one time component to total equation of time
  def angle_delta_orbit()           
    -1.0 * eqc( @ma, @ta ) 
  end  
  alias_method :delta_t_elliptic, :angle_delta_orbit
  alias_method :delta_orbit, :angle_delta_orbit
  
  
  # From angles.rb:   
  # component of equation of equinox
  def angle_delta_psi()   
    Celes.nut06a(@ajd, 0)[ 0 ]
  end
  alias_method :delta_psi, :angle_delta_psi
  
  # From angles.rb:   
  # total equation of time  
  def angle_equation_of_time()    
    delta_orbit() + delta_oblique()
  end
  alias_method :eot, :angle_equation_of_time 

  # From angles.rb:   
  # equation of centre
  # added to mean anomaly to get true anomaly. 
  def center()      
    # sine_1M = sin( 1.0 * @ma )
    # sine_2M = sin( 2.0 * @ma )
    # sine_3M = sin( 3.0 * @ma )
    # sine_4M = sin( 4.0 * @ma )
    # sine_5M = sin( 5.0 * @ma )
    # e = eccentricity_Earth()
    # sine_1M * (  2.0       * e    - e**3 * 1.0/4.0 + 5/96.0 * e**5 ) +  
    # sine_2M * (  5.0/4.0   * e**2 - 11/24.0 * e**4 )               + 
    # sine_3M * ( 13.0/12.0  * e**3 - 43/64.0 * e**5 )               +
    # sine_4M *  103.0/96.0  * e**4                                  +
    # sine_5M * 1097.0/960.0 * e**5                              
    # sine_1M * ( 1.914602 - @ta * ( 0.004817 + @ta * 0.000014 )) +                                               +
    # sine_2M * ( 0.019993 - @ta * 0.000101 )                     +                                              +
    # sine_3M *  0.000289
    eqc( @ma, @ta )
  end
  alias_method :equation_of_center, :center
  
  # From angles.rb:   
  # cosine apparent longitude
  # could be useful when dividing 
  def cosine_al_Sun()    
    cos( al(@ma, @ta, Celes.faom03(@ta)) ) 
  end
  alias_method :cosine_apparent_longitude, :cosine_al_Sun
  alias_method :cosalsun, :cosine_al_Sun
  
  # From angles.rb:   
  # cosine true longitude
  # used in solar right ascension  
  def cosine_tl_Sun()    
    cos( tl(@ma, @ta) ) 
  end
  alias_method :cosine_true_longitude, :cosine_tl_Sun
  
  # From angles.rb:   
  # cosine true obliquity
  # used in solar right ascension and equation of equinox 
  def cosine_to_Earth()    
    cos( Celes.nut06a(@ajd, 0)[ 1 ] + Celes.obl06(@ajd, 0) ) 
  end
  alias_method :cosine_true_obliquity, :cosine_to_Earth
  
  # From angles.rb:   
  # solar declination
  def dec_Sun()   
    asin( sin(Celes.nut06a(@ajd, 0)[ 1 ] + Celes.obl06(@ajd, 0)) * 
            sin( al(@ma, @ta, Celes.faom03(@ta)))) 
  end
  alias_method :declination, :dec_Sun
  
  
  # From angles.rb:   
  # eccentricity of elliptical Earth orbit around Sun
  # Horners' calculation method  
  def eccentricity_Earth()
    # [-0.0000001235, -0.000042037, 0.016708617].inject(0.0) {|p, a| p * @ta + a}
    eoe(@ta) 
  end
  alias_method :eccentricity_earth_orbit, :eccentricity_Earth
  
  # From angles.rb:   
  # equation of equinox
  # used for true longitude of Aries 
  # Depricated by Celes.gst06a()  
  def eq_of_equinox()   
    cos( Celes.nut06a(@ajd, 0)[ 1 ] + Celes.obl06(@ajd, 0) ) * Celes.nut06a(@ajd, 0)[ 0 ]
  end
  

  # From angles.rb:   
  # angle geometric mean longitude
  # needed to get true longitude for low accuracy.  
  def gml_Sun()    
    #total = [ 1.0/-19880000.0, 1.0/-152990.0, 1.0/499310.0,
    #		 0.0003032028, 36000.76982779, 280.4664567 ] 
    # mod_360(total.inject(0.0) {|p, a| p * @ta + a}) * D2R
    ml(@ta)
  end
  alias_method :geometric_mean_longitude, :gml_Sun

  # From angles.rb:   
  # horizon angle for provided geo coordinates
  # used for angles from transit to horizons  
  def ha_Sun()
    zenith   = 90.8333 # use other zeniths here for non commercial    
    top      = cosZ( zenith ) - sin( dec_Sun() ) * sin( @latitude * D2R )
    bottom   = cos( dec_Sun() ) * cos( @latitude * D2R )
    t_cosine = top / bottom 
    t_cosine > 1.0 || t_cosine < -1.0 ? cos = 1.0 : cos = t_cosine
    acos( cos )  
  end
  alias_method :horizon_angle, :ha_Sun  
 
  # From angles.rb:   
  # angle of Suns' mean anomaly
  # calculated in nutation.rb via celes function
  # sets ta attribute for the rest the methods needing it.
  # used in equation of time
  # and to get true anomaly true longitude via center equation  
  def ma_Sun()
    @ta = ( @ajd - DJ00 ) / DJC     
#    @ma = delta_equinox()[2]
    @ma = Celes.falp03(@ta)       
  end
  alias_method :mean_anomaly, :ma_Sun
  
  # From angles.rb:   
  # Mean equinox point where right ascension is measured from as zero hours.
  # # see http://www.iausofa.org/publications/aas04.pdf 
  def ml_Aries()   
    # jd     = @ta * DJC # convert first term back to jdn - J2000
    # old terms  	
    # angle  = (36000.770053608 / DJC + 360) * jd  # 36000.770053608 = 0.9856473662862 * DJC
    # total = [ -1.0/3.8710000e7, 3.87930e-4, 0, 100.460618375 ].inject(0.0) {|p, a| p * ta[0] + a} + 180 + angle  
    # newer terms seem to be in arcseconds / 15.0
    # 0.0000013, - 0.0000062, 0.0931118, 307.4771600, 8639877.3173760, 24110.5493771
    # angle  = (35999.4888224 / DJC + 360) * jd     
    # total  = angle +   280.460622404583   +
    #  @ta[ 0 ] *  1.281154833333   +
    #  @ta[ 1 ] *  3.87965833333e-4 +
    # @ta[ 2 ] * -2.58333333333e-8 +
    # @ta[ 3 ] *  5.41666666666e-9
    # total = [5.41666666666e-9, -2.58333333333e-8, 3.87965833333e-4, 1.281154833333, 280.460622404583].inject(0.0) {|p, a| p * @ta + a}          
    # mod_360( angle + total )  * D2R
    dt = 67.184   
    tt = @ajd + dt / 86400.0#Celes.ut1tt(@ajd, 0, dt)
    Celes.gmst06(@ajd, 0, tt, 0)    
  end
  alias_method :mean_longitude_aries, :ml_Aries
  
  # From angles.rb:   
  # mean obliquity of Earth  
  def mo_Earth()     
#    [ -0.0000000434, -0.000000576,  0.00200340, 
#      -0.0001831,   -46.836769, 84381.406 ].inject(0.0) {|p, a| p * @ta + a} * DAS2R
    Celes.obl06(@ajd, 0)
  end
  alias_method :mean_obliquity_of_ecliptic, :mo_Earth
  alias_method :mean_obliquity, :mo_Earth
  
  # From angles.rb:   
  # omega is a component of nutation and used 
  # in apparent longitude 
  # omega is the longitude of the mean ascending node of the lunar orbit 
  # on the ecliptic plane measured from the mean equinox of date. 
  def omega()    
    # delta_equinox()[ 3 ]
    Celes.faom03(@ta)      
  end
  
  # From angles.rb:   
  # solar right ascension
  def ra_Sun()    
    y0 = sin( al(@ma, @ta, Celes.faom03(@ta)) ) * cos( Celes.nut06a(@ajd, 0)[ 1 ] + 
         Celes.obl06(@ajd, 0) )
    Celes.anp( PI + atan2( -y0, -cos( al(@ma, @ta, Celes.faom03(@ta)) ) ) )  
  end
  alias_method :right_ascension, :ra_Sun
  
  # From angles.rb:   
  # sine apparent longitude
  # used in solar declination  
  def sine_al_Sun()
    sin( al(@ma, @ta, Celes.faom03(@ta)) ) 
  end
  alias_method :sine_apparent_longitude, :sine_al_Sun
  
  # From angles.rb:   
  # sine true longitude
  # used in solar right ascension 
  def sine_tl_Sun()    
    sin( tl(@ma, @ta) ) 
  end
  alias_method :sine_true_longitude, :sine_tl_Sun
  
# From angles.rb:   
  # sine true obliquity angle of Earth
  # used in solar declination 
  def sine_to_Earth()
    sin(Celes.nut06a(@ajd, 0)[ 1 ] + Celes.obl06(@ajd, 0))
  end

  # From angles.rb:   
  # angle true anomaly
  # used in equation of time  
  def ta_Sun()     
    Celes.anp(@ma + eqc( @ma, @ta ))	
  end
  alias_method :true_anomaly, :ta_Sun 

  # From angles.rb:   
  # true longitude of equinox 'first point of aries'
  # considers nutation 
  def tl_Aries()     
    # Celes.anp(eq_of_equinox() + ml_Aries())
    dt = 67.184   
    tt = @ajd + dt / 86400.0#Celes.ut1tt(@ajd, 0, dt)    
    Celes.gst06a(@ajd, 0, tt, 0)    
  end
  alias_method :true_longitude_aries, :tl_Aries  
  
  # From angles.rb:   
  # angle of true longitude sun
  # used in equation of time 
  def tl_Sun()   
    #Celes.anp(gml_Sun() + center())
    tl(@ma, @ta) 	 
  end
  alias_method :true_longitude, :tl_Sun
  alias_method :ecliptic_longitude, :tl_Sun
  alias_method :lambda, :tl_Sun
  
  # From angles.rb:   
  # true obliquity considers nutation  
  def to_Earth()   
    Celes.nut06a(@ajd, 0)[ 1 ] + Celes.obl06(@ajd, 0)     
  end
  alias_method :obliquity_correction, :to_Earth
  alias_method :true_obliquity, :to_Earth
  alias_method :toearth, :to_Earth

end

if __FILE__ == $PROGRAM_NAME

  spec = File.expand_path('../../../test/', __FILE__)
  $LOAD_PATH.unshift(spec) unless $LOAD_PATH.include?(spec)
  require 'angles_spec'
  require 'aliased_angles_spec'

end