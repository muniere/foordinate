require "spec"
require "./spec_helper"

describe "File" do

  describe ".purename" do

    it "gets purename of file path" do
      File.purename("/foo/bar/fizz.txt").should eq("fizz")
      File.purename("buzz.txt").should eq("buzz")
    end

  end

  describe ".prefix" do

    it "gets prefix of file path" do
      File.prefix("/foo/bar/fizz_001.txt").should eq("fizz_")
      File.prefix("buzz_1234.jpg").should eq("buzz_")
      File.prefix("foobar.cr").should eq("foobar")
      File.prefix("12345.png").should eq(nil)
    end

  end

  describe ".head" do

    it "gets head elements of absolute path" do
      File.head("/foo/bar/fizz/buzz.txt", length: 10).should eq("/foo/bar/fizz/buzz.txt")
      File.head("/foo/bar/fizz/buzz.txt", length: 3).should eq("/foo/bar/fizz")
      File.head("/foo/bar/fizz/buzz.txt").should eq("/foo")
    end

    it "gets head elements of relative path" do
      File.head("foo/bar/fizz/buzz.txt", length: 10).should eq("foo/bar/fizz/buzz.txt")
      File.head("foo/bar/fizz/buzz.txt", length: 3).should eq("foo/bar/fizz")
      File.head("foo/bar/fizz/buzz.txt").should eq("foo")
    end

  end

  describe ".tail" do

    it "gets tail elements of absolute path" do
      File.tail("/foo/bar/fizz/buzz.txt", length: 10).should eq("/foo/bar/fizz/buzz.txt")
      File.tail("/foo/bar/fizz/buzz.txt", length: 3).should eq("/bar/fizz/buzz.txt")
      File.tail("/foo/bar/fizz/buzz.txt").should eq("/buzz.txt")
    end

    it "gets tail elements of relative path" do
      File.tail("foo/bar/fizz/buzz.txt", length: 10).should eq("foo/bar/fizz/buzz.txt")
      File.tail("foo/bar/fizz/buzz.txt", length: 3).should eq("bar/fizz/buzz.txt")
      File.tail("foo/bar/fizz/buzz.txt").should eq("buzz.txt")
    end

  end
end
