class Kindletool < Formula
  desc "Tool for creating/extracting Kindle updates and more"
  homepage "https://github.com/NiLuJe/KindleTool"
  url "https://ghproxy.com/https://github.com/NiLuJe/KindleTool/archive/v1.6.5.tar.gz"
  sha256 "949cbbd3390a10cb86ebff870a3e00566dbef33630fddb2cbd5ff81f90fb4030"

  head "https://github.com/NiLuJe/KindleTool.git", shallow: false

  depends_on "pkg-config" => :build

  depends_on "libarchive"
  depends_on "nettle"

  def install
    # Make sure the buildsystem will be able to generate a proper version tag
    ENV["GIT_DIR"] = cached_download/".git" if build.head?

    system "make"
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX=/."
  end
end