class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://ghfast.top/https://github.com/widelands/widelands/archive/refs/tags/v1.3.tar.gz"
  sha256 "8468b6bc0ddb70749c09c5603109ceeb79b95f3602d3aa55ecfad84f8ea82571"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "62311462c2370ab7780a7f8a8f301302471cde0140941e3dbca71825aee9eaf6"
    sha256 arm64_sequoia: "2ad0a9c6fa5606711857c4cdca2b6035ee33ad7b29e3f79af470ed2fdd089749"
    sha256 arm64_sonoma:  "fae160a4cbf9f8035d59bb39ba5e6eb1474e86ec2e9df352922f04389580fcc1"
    sha256 sonoma:        "3162aeeee565681c4641075d6eaa6961234ac2c1d88783350b3d3de4e2a8e1be"
    sha256 arm64_linux:   "eac299aa3f990e4e3754578f04af654190fa06d5bb1b430c4e8b4d21ce98f758"
    sha256 x86_64_linux:  "fe252f216e075910f75a8cc42d853a00dcc1c162cf1759aab478488928e0b644"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build

  depends_on "glew"
  depends_on "icu4c@78"
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
                    "-DWL_INSTALL_DATADIR=#{pkgshare}/data",
                    "-DOPTION_BUILD_CODECHECK=OFF",
                    "-DOPTION_BUILD_TESTS=OFF",
                    "-DOPTION_BUILD_WEBSITE_TOOLS=OFF",
                    "-DPYTHON_EXECUTABLE=#{which("python3")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    if OS.linux?
      # Unable to start Widelands, because we were unable to add the home directory:
      # RealFSImpl::make_directory: No such file or directory: /tmp/widelands-test/.local/share/widelands
      mkdir_p ".local/share/widelands"
      mkdir_p ".config/widelands"
    end

    system bin/"widelands", "--version"
  end
end