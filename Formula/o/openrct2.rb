class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https:openrct2.io"
  url "https:github.comOpenRCT2OpenRCT2.git",
      tag:      "v0.4.12",
      revision: "1b5ff882d3e5902a80eec39a9c923eb8ed5c320d"
  license "GPL-3.0-only"
  head "https:github.comOpenRCT2OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "007465140d76d532c4794aecafb8c6906412949fccf9b8aa5829e91b716e1359"
    sha256 cellar: :any, arm64_ventura:  "a063398bbf2dcd8699e7c4e08ad741b20aac0f022c3239f715e4e03f526a2968"
    sha256 cellar: :any, arm64_monterey: "0d192f9b6702d6a0f7359320fe0a749a8060438eca36e1f7937c55caa0397499"
    sha256 cellar: :any, sonoma:         "8238bf13a0f9f634a6de7be21c10a4de757ac15bf1ea33f882e1f1ce9865f101"
    sha256 cellar: :any, ventura:        "c6a4af216409042272cc8c8a946918c5f9d2bda9d0791ebcf61fc6126ab90fb3"
    sha256 cellar: :any, monterey:       "5e8d6f77d98ae90704ab470f7b80eb541642144b02831eaa93ff3047c1a7c175"
    sha256               x86_64_linux:   "0ebcfea5973c2fa2bfa9a2b948ae5e79642c653d00479cb1422efc593ca0531a"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkg-config" => :build
  depends_on "duktape"
  depends_on "flac"
  depends_on "freetype"
  depends_on "icu4c"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libzip"
  depends_on macos: :mojave # `error: call to unavailable member function 'value': introduced in macOS 10.14`
  depends_on "openssl@3"
  depends_on "sdl2"
  depends_on "speexdsp"

  on_linux do
    depends_on "curl"
    depends_on "fontconfig"
    depends_on "mesa"
  end

  fails_with gcc: "5" # C++17

  resource "title-sequences" do
    url "https:github.comOpenRCT2title-sequencesreleasesdownloadv0.4.6title-sequences.zip"
    sha256 "24a189cdaf1f78fb6d6caede8f1ab3cedf8ab9f819cd2260a09b2cce4c710d98"
  end

  resource "objects" do
    url "https:github.comOpenRCT2objectsreleasesdownloadv1.4.6objects.zip"
    sha256 "5a8b54d021e167604051fd508da109d9ebc660638f57252bba729f76bb246387"
  end

  def install
    # Avoid letting CMake download things during the build process.
    (buildpath"datatitle").install resource("title-sequences")
    (buildpath"dataobject").install resource("objects")

    mkdir "build" do
      cmake_args = [
        "-DWITH_TESTS=OFF",
        "-DDOWNLOAD_TITLE_SEQUENCES=OFF",
        "-DDOWNLOAD_OBJECTS=OFF",
        "-DMACOS_USE_DEPENDENCIES=OFF",
        "-DDISABLE_DISCORD_RPC=ON",
      ]
      cmake_args << "-DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}" if OS.mac?
      system "cmake", "..", *std_cmake_args, *cmake_args

      system "make", "install"
    end

    # By default macOS build only looks up data in app bundle Resources
    libexec.install bin"openrct2"
    (bin"openrct2").write <<~EOS
      #!binbash
      exec "#{libexec}openrct2" "$@" "--openrct2-data-path=#{pkgshare}"
    EOS
  end

  test do
    assert_match "OpenRCT2, v#{version}", shell_output("#{bin}openrct2 -v")
  end
end