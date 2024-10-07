class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https:openrct2.io"
  url "https:github.comOpenRCT2OpenRCT2.git",
      tag:      "v0.4.15",
      revision: "c7c8fad822d10e7fbec26eeefbf2e552a02b8ea9"
  license "GPL-3.0-only"
  head "https:github.comOpenRCT2OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "92419c6910a2049dccf640aa079313d768181f8a1a437e1a5bb36fdac27c502c"
    sha256 cellar: :any, arm64_sonoma:  "a16552f8463a469fab6ee3b9b6cfaf0dedf9a0b674438b8801303344ae3874f3"
    sha256 cellar: :any, arm64_ventura: "7a07f617a0e90a83835b9a14071d61f2cd86d1751b5fa2b8bfd8a9970d0afb12"
    sha256 cellar: :any, sonoma:        "4a1a0f4a913854291b904130697354d6effe63837f96bb6f31f65703eee3c62d"
    sha256 cellar: :any, ventura:       "3de39f8ebc55df89fb8d045f18d600179ad93baa041a85caca3f79ed4c25afab"
    sha256               x86_64_linux:  "dc110fd1dbf71ab7a49b84d636fd8063586281512d94099cb0faaf96485977dc"
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

  uses_from_macos "zlib"

  on_linux do
    depends_on "curl"
    depends_on "fontconfig"
    depends_on "mesa"
  end

  fails_with gcc: "5" # C++17

  resource "title-sequences" do
    url "https:github.comOpenRCT2title-sequencesreleasesdownloadv0.4.14title-sequences.zip"
    sha256 "140df714e806fed411cc49763e7f16b0fcf2a487a57001d1e50fce8f9148a9f3"
  end

  resource "objects" do
    url "https:github.comOpenRCT2objectsreleasesdownloadv1.4.8objects.zip"
    sha256 "ea78872f9f777fb6b27019e4b880e4cb9766658ee8ae95f76985af0b9658eb4d"
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
    (bin"openrct2").write <<~EOS
      #!binbash
      exec "#{libexec}openrct2" "$@" "--openrct2-data-path=#{pkgshare}"
    EOS
  end

  test do
    assert_match "OpenRCT2, v#{version}", shell_output("#{bin}openrct2 -v")
  end
end