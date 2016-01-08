require "spec"
require "./spec_helper"

private def fixture(filename : String) : Pathname
  return Pathname.new(File.join(__DIR__, "../fixt/rename_spec", filename))
end

private def fixture(filenames : Array(String)) : Array(Pathname)
  return filenames.map { |f| fixture(f) }
end

describe "Rename" do

  describe "#numberization" do

    it "constructs rules for numberization with default prefix" do
      pathnames = fixture([
        "bar.gif",
        "foo.png",
        "hoge.jpg",
      ])

      options = Rename::NumberizeOptions.new(length: 5)

      rules = Rename.new.numberization(pathnames, options: options)

      rules.map { |r| r.dst }.should eq fixture([
        "bar_00001.gif",
        "foo_00002.png",
        "hoge_00003.jpg",
      ])
    end

    it "constructs rules for numberization with no prefix" do
      pathnames = fixture([
        "bar.gif",
        "foo.png",
        "hoge.jpg",
      ])

      options = Rename::NumberizeOptions.new(length: 5, prefix: "")

      rules = Rename.new.numberization(pathnames, options: options)

      rules.map { |r| r.dst }.should eq fixture([
        "00001.gif",
        "00002.png",
        "00003.jpg",
      ])
    end
  end

  describe "#randomization" do

    it "constructs rules for randomization with default prefix" do
      pathnames = fixture([
        "bar.gif",
        "foo.png",
        "hoge.jpg",
      ])

      options = Rename::RandomizeOptions.new(length: 5)

      rules = Rename.new.randomization(pathnames, options: options)

      rules[0].dst.path.should match(/bar_\d{5}\.gif/)
      rules[1].dst.path.should match(/foo_\d{5}\.png/)
      rules[2].dst.path.should match(/hoge_\d{5}\.jpg/)
    end

    it "constructs rules for randomization with no prefix" do
      pathnames = fixture([
        "bar.gif",
        "foo.png",
        "hoge.jpg",
      ])

      options = Rename::RandomizeOptions.new(length: 5, prefix: "")

      rules = Rename.new.randomization(pathnames, options: options)

      rules[0].dst.path.should match(/\d{5}\.gif/)
      rules[1].dst.path.should match(/\d{5}\.png/)
      rules[2].dst.path.should match(/\d{5}\.jpg/)
    end
  end
end
