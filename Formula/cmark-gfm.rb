class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark-gfm"
  url "https://ghproxy.com/https://github.com/github/cmark-gfm/archive/0.29.0.gfm.10.tar.gz"
  version "0.29.0.gfm.10"
  sha256 "0656ca84ec677b87841f8088184c4b62777de3069bacefa18e621dc18c5d7864"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "13d13ff44caeabcbb158ba349301246ab24690b859eb0ec14fd84d0c1a0c526e"
    sha256 cellar: :any,                 arm64_monterey: "b24e7e9a2c064e700446e37fad4ffe3c94f4b1837909def2f5d4d0e7c4b200dd"
    sha256 cellar: :any,                 arm64_big_sur:  "09de6a8851fa631e6cf17398646c245d8a73b57e8456a012786714f1084dea6e"
    sha256 cellar: :any,                 ventura:        "c4dcd0b8e1b19151f2292ba99b6cabe0add05b7c239c0fba5c87719512cdd9fc"
    sha256 cellar: :any,                 monterey:       "6fb0fa6e3b059aa1356e35066d5f8c41ddc9b6b32a3fce8a92063ec8e773530d"
    sha256 cellar: :any,                 big_sur:        "b49341e6dd315d7efad2e1eb5c5082d44d4642fcc177369bdd3ab56066b6bd13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87c1cae2789430d54d7ce8e7eeddccdaa8c8f68389d3b5da9467b89489942498"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  conflicts_with "cmark", because: "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark-gfm --extension autolink", "https://brew.sh")
    assert_equal '<p><a href="https://brew.sh">https://brew.sh</a></p>', output.chomp
  end
end