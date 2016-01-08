require "logger"

#
# Rename action
#
class Rename

  #
  # Options
  #
  class Options

    property dry_run   :: Bool
    property overwrite :: Bool

    def initialize(
      @dry_run   = false,
      @overwrite = false,
    )
    end
  end

  #
  # Properties
  #
  property logger :: Logger?

  #
  # Initialize action
  #
  def initialize(
    @logger = nil
  )
  end

  #
  # Run rename action
  #
  # @param rules
  # @param options
  #
  def run(rules : Array(Rule), options = Options.new)

    #
    # validate
    #
    conflicts = rules.select(&.conflicts?)

    if !options.overwrite && !conflicts.empty?
      conflicts.each do |rule|
        @logger.try(&.error("File already exists: #{rule.dst.path}"))
      end

      raise Exception.new
    end

    #
    # rename
    #
    pretty_s = self.pretty(rules, depth: 2)

    if options.dry_run
      STDOUT.puts(pretty_s)
      return
    end

    rules.zip(pretty_s.lines.map(&.strip)).each do |arr|
      rule, line = arr
      @logger.try(&.info(line))
      rule.run
    end
  end
end

#
# Numberize
#
class Rename

  #
  # Options for numberize
  #
  class NumberizeOptions < Options

    property length  :: Int
    property start   :: Int
    property prefix  :: String?

    def initialize(
      @length    = 3, 
      @start     = 1, 
      @prefix    = nil,
      @dry_run   = false,
      @overwrite = false,
    )
    end
  end

  #
  # Numberize given paths
  #
  # @param pathnames Pathnames to rename
  # @param options Options for numberize
  #
  def numberize(pathnames : Array(Pathname), options = NumberizeOptions.new) 
    rules = self.numberization(pathnames, options: options)
    self.run(rules, options: options)
  end

  #
  # Construct rules to numberize given paths
  #
  # @param pathnames Pathnames to rename
  # @param options Options for numberize
  # @return Constructed rules
  #
  def numberization(pathnames : Array(Pathname), options = NumberizeOptions.new) : Array(Rule)
    return self.compact(pathnames)
      .sort_by(&.basename)
      .reject(&.basename.starts_with?("."))
      .map_with_index { |pathname, index|
        prefix_s = options.prefix || File.prefix(pathname.path, padding: "_") || "" 
        number_s = (options.start + index).to_s.rjust(options.length, '0')

        new_name = prefix_s + number_s + pathname.extname
        new_path = File.join(pathname.dirname, new_name).sub(%r(^\./), "")

        next Rule.new(src: pathname, dst: Pathname.new(new_path))
      }
  end
end

#
# Randomize
#
class Rename

  #
  # Options for randomize
  #
  class RandomizeOptions < Options

    property length  :: Int
    property prefix  :: String?

    def initialize(
      @length    = 10, 
      @prefix    = nil,
      @dry_run   = false,
      @overwrite = false,
    )
    end
  end

  #
  # Randomize given paths
  #
  # @param pathnames Pathnames to rename
  # @param options Options for randomize
  #
  def randomize(pathnames : Array(Pathname), options = RandomizeOptions.new)
    rules = self.randomization(pathnames, options: options)
    self.run(rules, options: options)
  end

  #
  # Construct rules to randomize given paths
  #
  # @param pathnames Pathnames to rename
  # @param options Options for randomize
  # @return Constructed rules 
  #
  def randomization(pathnames : Array(Pathname), options = RandomizeOptions.new)
    return self.compact(pathnames)
      .sort_by(&.basename)
      .reject(&.basename.starts_with?("."))
      .map_with_index { |pathname, index|
        prefix_s = options.prefix || File.prefix(pathname.path, padding: "_") || "" 
        number_s = (0...options.length).map { |n| rand(10).to_s }.join

        new_name = prefix_s + number_s + pathname.extname
        new_path = File.join(pathname.dirname, new_name).sub(%r(^\./), "")

        next Rule.new(src: pathname, dst: Pathname.new(new_path))
      }
  end
end

#
# Helper
#
class Rename

  #
  # Compact pathnames
  #
  # @param pathname
  # @return Compacted pathnames
  #
  protected def compact(pathnames : Array(Pathname)) : Array(Pathname)
    pathnames.compact_map { |pathname|
      unless pathname.exists?
        @logger.try(&.warn("File NOT FOUND: #{pathname.path}"))
        next nil
      end

      next pathname
    }
  end

  #
  # Generate pretty formatted string
  #
  # @param rules Rules for pretty print
  # @param depth Depth of path names
  # @return Pretty formatted string
  #
  protected def pretty(rules : Array(Rule), depth = nil : Int?) : String
    if !depth.nil?
      pretty_rules = rules.map { |rule|
        next Rule.new(
          src: Pathname.new(File.tail(rule.src.path, length: depth)),
          dst: Pathname.new(File.tail(rule.dst.path, length: depth)),
        )
      }
    else
      pretty_rules = rules
    end

    src_width = pretty_rules.map(&.src.path.size).max
    dst_width = pretty_rules.map(&.dst.path.size).max

    return pretty_rules.map { |rule|
      next "%s => %s" % [
        rule.src.path.ljust(src_width),
        rule.dst.path.ljust(dst_width)
      ]
    }.join("\n")
  end
end

#
# Rule
#
class Rename::Rule

  #
  # Properties
  #
  property src :: Pathname
  property dst :: Pathname

  #
  # Initialize action
  #
  # @param src
  # @param dst
  #
  def initialize(
    @src = nil : Pathname,
    @dst = nil : Pathname
  )
  end

  #
  # Execute rename action
  #
  def run 
    File.rename(@src.path, @dst.path) 
  end

  #
  # Detect if conflicts with eisting file
  #
  # @return True if conflicts
  #
  def conflicts? : Bool
    return @dst.exists?
  end
end
