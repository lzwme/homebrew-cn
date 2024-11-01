class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https:www.widelands.org"
  url "https:github.comwidelandswidelandsarchiverefstagsv1.2.tar.gz"
  sha256 "c6bed3717c541276fbed8a33adce230a2637297588c719268fcb963e076210e2"
  license "GPL-2.0-or-later"
  revision 2
  version_scheme 1

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "ea622071da61757e744d812326cbc8b31a7a822f81090acc233ce28ba7c45684"
    sha256 arm64_sonoma:  "2240e9f7aa02fa0d52cb15ccab35d09526b43b221d77870d96d11c2a8abdfd98"
    sha256 arm64_ventura: "7098fe65d2ea70361f15f302bd7b2afe0307d6cc75fea5fc2eedd151eea61ce6"
    sha256 sonoma:        "1fb275dfe64f2dedd8e92c5ae13383dab1b6b9ba9196f39a4a66833889332f60"
    sha256 ventura:       "a3c929405dc321113ec2e9e459aa3c19b0ccc25ca61234c48c05888fca6caf78"
    sha256 x86_64_linux:  "5188b857c4b567851bfc82ffc660662f66c925cd75a06b1442a1bdee02dfddfc"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build

  depends_on "glew"
  depends_on "icu4c@76"
  depends_on "libpng"
  depends_on "lua"
  depends_on "minizip"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "mesa"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DWL_INSTALL_BASEDIR=#{pkgshare}",
                    "-DWL_INSTALL_BINDIR=#{bin}",
                    "-DWL_INSTALL_DATADIR=#{pkgshare}data",
                    "-DOPTION_BUILD_CODECHECK=OFF",
                    "-DOPTION_BUILD_TESTS=OFF",
                    "-DOPTION_BUILD_WEBSITE_TOOLS=OFF",
                    "-DPYTHON_EXECUTABLE=#{which("python3") || which("python")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    if OS.linux?
      # Unable to start Widelands, because we were unable to add the home directory:
      # RealFSImpl::make_directory: No such file or directory: tmpwidelands-test.localsharewidelands
      mkdir_p ".localsharewidelands"
      mkdir_p ".configwidelands"
    end

    system bin"widelands", "--version"
  end
end