require "logger"

#
# Count action
#
class Count

  #
  # Count options
  #
  class Options

    property all     :: Bool
    property pattern :: String?

    def initialize(
      @all     = false,
      @pattern = nil,
    )
    end
  end

  #
  # Constants
  #
  JUST_WIDTH = 5

  #
  # Properties
  #
  property io     :: IO
  property logger :: Logger?

  #
  # Initialize action
  #
  def initialize(
    @io     = STDOUT,
    @logger = nil
  )
  end

  #
  # Execute count action
  #
  # @param pathnames
  # @param options
  #
  def run(pathnames : Array(Pathname), options = Options.new)

    #
    # compact
    #
    compacts = pathnames.compact_map { |pathname|
      if !options.all && pathname.path =~ /^\./
        @logger.try(&.debug("Skip hidden directory: #{pathname.path}"))
        next nil
      end

      unless pathname.exists?
        @logger.try(&.warn("File NOT FOUND: #{pathname.path}"))
        next nil
      end

      if pathname.file?
        @logger.try(&.info("File is not a directory: #{pathname.path}"))
        next nil
      end

      next pathname
    }

    #
    # count
    #
    width = compacts.map(&.path.size).max

    compacts.each do |pathname|

      @logger.try(&.debug("Count files in directory: #{pathname.path}"))

      if pathname.directory?
        children = Dir.glob(File.join(pathname.path, "*")).map { |p| Pathname.new(p) }
      else
        children = Array(Pathname).new
      end

      children_f = children.select(&.file?).select { |p|
        options.pattern.nil? || /#{options.pattern}/ =~ p.path
      }

      children_d = children.select(&.directory?).select { |p|
        options.pattern.nil? || /#{options.pattern}/ =~ p.path
      }

      line = "%s %s %s" % [
        pathname.path.to_s.ljust(width),
        children_f.size.to_s.rjust(JUST_WIDTH),
        children_d.size.to_s.rjust(JUST_WIDTH)
      ]

      @io.try(&.puts(line))
    end
  end
end
