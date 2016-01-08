#
# Transplant of Pathname of ruby
#
class Pathname

  getter path :: String

  def initialize(@path : String)
  end

  def basename : String
    return File.basename(@path)
  end

  def dirname : String
    return File.dirname(@path)
  end

  def extname : String
    return File.extname(@path)
  end

  def base_pathname : Pathname
    return Pathname.new(self.basename)
  end

  def dir_pathname : Pathname
    return Pathname.new(self.dirname)
  end

  def rel_path : String
    return @path
  end

  def rel_pathname : Pathname
    return Pathname.new(self.rel_path)
  end

  def abs_path : String
    return File.expand_path(@path)
  end

  def abs_pathname : Pathname
    return Pathname.new(self.abs_path)
  end

  def exists? : Bool
    return File.exists?(self.abs_path)
  end

  def file? : Bool
    return File.file?(self.abs_path)
  end

  def directory? : Bool
    return File.directory?(self.abs_path)
  end

  def children : Array(Pathname)
    unless self.directory?
      return Array(Pathname).new
    end

    return Dir.glob(File.join(@path, "*")).map { |path| 
      next Pathname.new(path) 
    }
  end

  def ==(other)
    return @path == other.path
  end
end
