#
# Extension of standard File class
#
class File

  #
  # Get basename without extname
  #
  # @return Purrename
  #
  def self.purename(path : String) : String
    return self.basename(path, self.extname(path))
  end

  #
  # Get prefix of file 
  #
  # @param path 
  # @param padding 
  # @return Prefix of file
  #
  def self.prefix(path : String, padding = nil : String?) : String?

    purename = self.purename(path)

    if purename =~ /^\d+/
      return nil
    end

    prefix = purename.sub(/\d+$/, "")

    unless padding.is_a?(String)
      return prefix
    end

    if prefix.ends_with?(padding)
      return prefix
    else
      return prefix + padding
    end
  end

  #
  # Get path with first n elements
  #
  # @param path 
  # @param length 
  # @return Path with first n elements
  #
  def self.head(path : String, length = 1 : Int) : String

    absolute? = path.starts_with?(File::SEPARATOR)

    splitted = path.sub(%r(^/), "").split(File::SEPARATOR)
    selected = splitted[0..Math.min(length - 1, splitted.size - 1)]

    if absolute?
      return File.join(selected.insert(0, File::SEPARATOR.to_s))
    else
      return File.join(selected)
    end
  end

  #
  # Get path with last n elements
  #
  # @param path
  # @param length 
  # @return Path with last n elements
  #
  def self.tail(path, length = 1 : Int)

    absolute? = path.starts_with?(File::SEPARATOR)

    splitted = path.sub(%r(^/), "").split(File::SEPARATOR)
    selected = splitted[Math.max(splitted.size - length, 0)..-1]

    if absolute?
      return File.join(selected.insert(0, File::SEPARATOR.to_s))
    else
      return File.join(selected)
    end
  end
end

