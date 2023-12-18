class Libwbxml < Formula
  desc "Library and tools to parse and encode WBXML documents"
  homepage "https:github.comlibwbxmllibwbxml"
  url "https:github.comlibwbxmllibwbxmlarchiverefstagslibwbxml-0.11.8.tar.gz"
  sha256 "a6fe0e55369280c1a7698859a5c2bb37c8615c57a919b574cd8c16458279db66"
  license "LGPL-2.1"
  head "https:github.comlibwbxmllibwbxml.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "96d521767660b9f716d38654a02dbc9aa9a6eea639808b7ab67c3847edc525b5"
    sha256 cellar: :any,                 arm64_ventura:  "98d058e5bcb1eb4846a21d474774cbec312ce4b49c37585eae02c601c64e201e"
    sha256 cellar: :any,                 arm64_monterey: "fe2ac6ea506094bb84685b873d59cb9b0ea225b2ce56cb13b2fc1197bcd6b906"
    sha256 cellar: :any,                 arm64_big_sur:  "ac5e42ae5a76a5d3cf1d731b80b40ae019ffd90c0cef0ea4ad24d700958f3dc3"
    sha256 cellar: :any,                 sonoma:         "2609521b850d61fc4164142ffe21e9530653586013e40a3fdac4ca790a79d860"
    sha256 cellar: :any,                 ventura:        "a3d9904a0466a386a6572f5dbe8834960511574475511cc5096e5751c5a2c1c1"
    sha256 cellar: :any,                 monterey:       "08e5267c81b874f8115b1fb110a3a0553553863b139c950e60aeead99701ac7f"
    sha256 cellar: :any,                 big_sur:        "1d656b5fd3c1c1486db641b7e00a129b71071c1f26a522dad2bc29795d6c2a85"
    sha256 cellar: :any,                 catalina:       "1a5739cb2c803bc0580ef5cab2c58effaa2d849f7f0d55060f325a5cd9cf8ec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec4cdd3a2ead2da218798ef2a020fe2ef66f18b44d6a995977838af60257e8a2"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "wget"

  uses_from_macos "expat"

  def install
    # Sandbox fix:
    # Install in Cellar & then automatically symlink into top-level Module path
    inreplace "cmakeCMakeLists.txt", "${CMAKE_ROOT}Modules",
                                      "#{share}cmakeModules"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DBUILD_DOCUMENTATION=ON",
                            "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end
end