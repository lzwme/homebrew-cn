class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https:openrct2.io"
  url "https:github.comOpenRCT2OpenRCT2.git",
      tag:      "v0.4.16",
      revision: "c1082a3d6ca9167832578fc50c0d128b565943c9"
  license "GPL-3.0-only"
  head "https:github.comOpenRCT2OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "ed4b9c46d1d05fb3f09f062a0f21dc951fa3bae5874c27c63ed41cfa243b7a45"
    sha256 cellar: :any, arm64_sonoma:  "ad45f51ef7799272bb85ac9fadbdc702729541f850209fc0ccbc4494a1d4d916"
    sha256 cellar: :any, arm64_ventura: "d3e0fa9e761649871ed6b44b25b4bede1d3026d7841df614b334f73dbc2537a1"
    sha256 cellar: :any, sonoma:        "f68641e10f43a793b3f4d82326a258730ca997c8e158f82c3a36c6c13a591148"
    sha256 cellar: :any, ventura:       "7de4b01a20363523dec7c9fd5e16dcbc4cf988a5416e2e88ccaa0576ec847421"
    sha256               x86_64_linux:  "db5270c1970bc9c31f41c7c40f73821276eb1387022674842e377413dd5edfd4"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build

  depends_on "duktape"
  depends_on "flac"
  depends_on "freetype"
  depends_on "icu4c@76"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libzip"
  depends_on macos: :mojave # `error: call to unavailable member function 'value': introduced in macOS 10.14`
  depends_on "openssl@3"
  depends_on "sdl2"
  depends_on "speexdsp"

  uses_from_macos "zlib"

  on_linux do
    depends_on "curl"
    depends_on "fontconfig"
    depends_on "mesa"
  end

  resource "title-sequences" do
    url "https:github.comOpenRCT2title-sequencesreleasesdownloadv0.4.14title-sequences.zip"
    sha256 "140df714e806fed411cc49763e7f16b0fcf2a487a57001d1e50fce8f9148a9f3"
  end

  resource "objects" do
    url "https:github.comOpenRCT2objectsreleasesdownloadv1.4.10objects.zip"
    sha256 "186a05c91b9a6c328ad0994454033434fe864a8606c1d126485f7469a8e5539c"
  end

  def install
    # Avoid letting CMake download things during the build process.
    (buildpath"datatitle").install resource("title-sequences")
    (buildpath"dataobject").install resource("objects")

    args = [
      "-DWITH_TESTS=OFF",
      "-DDOWNLOAD_TITLE_SEQUENCES=OFF",
      "-DDOWNLOAD_OBJECTS=OFF",
      "-DMACOS_USE_DEPENDENCIES=OFF",
      "-DDISABLE_DISCORD_RPC=ON",
    ]
    args << "-DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # By default macOS build only looks up data in app bundle Resources
    libexec.install bin"openrct2"
    (bin"openrct2").write <<~BASH
      #!binbash
      exec "#{libexec}openrct2" "$@" "--openrct2-data-path=#{pkgshare}"
    BASH
  end

  test do
    assert_match "OpenRCT2, v#{version}", shell_output("#{bin}openrct2 -v")
  end
end