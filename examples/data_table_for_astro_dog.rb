# class that goes with equationoftime.herokuapp.com/analemma
class AnalemmaDataTable

  attr_accessor  :data, :finish, :start, :table, :html

  def initialize 
    @start        = Time.utc( 2014, "jan", 1, 12, 0, 0 ).to_s
    @start_jd     = Date.parse(@start).jd.to_s
    @finish       = Time.utc( 2014, "dec", 31, 12, 0, 0 ).to_s
    @finish_jd    = Date.parse(@finish).jd.to_s
    @span         = Date.parse( @finish ).jd - Date.parse( @start ).jd
    @file_path    = File.expand_path( File.dirname( __FILE__ ) + "/analemma_data.yml" )
    @data         = YAML::load( File.open( @file_path, 'r'), :safe => true ).freeze   
    @table        = ""
    @html         = ""

    (0..@span).each do |i|
      p @data[i]
#      @jd          = @data[i].fetch ":jd"
#      @date        = @data[i].fetch ":date"
#      @delta_1     = @data[i].fetch ":delta_1"
#      @delta_2     = @data[i].fetch ":delta_2"
#      @delta_t     = @data[i].fetch ":delta_t"
#      @declination = @data[i].fetch ":declination"
#      @transit     = @data[i].fetch ":transit"
    end      
  end
end

if __FILE__ == $PROGRAM_NAME
  
  begin
    require 'eot'
  rescue LoadError
    lib = File.expand_path('../../lib', __FILE__)
    $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
    require 'eot' 
  end
  
  require 'safe_yaml'
  require 'eot'
  
  adt = AnalemmaDataTable.new

end