class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https:openrct2.io"
  url "https:github.comOpenRCT2OpenRCT2.git",
      tag:      "v0.4.19.1",
      revision: "455f22bbca7b519f41d90705ee323df36b37ed9a"
  license "GPL-3.0-only"
  revision 1
  head "https:github.comOpenRCT2OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "151fc96e845d34a043ba5173dd308b91e245a2667c66ada76e5c588ae8dfb27d"
    sha256 cellar: :any, arm64_sonoma:  "be41a1165c36050fb56812f06f0005055c3a9b36f6607c77ae8a48cf70c02e47"
    sha256 cellar: :any, arm64_ventura: "0f9f20e65f091440b1f5f67d757504596b7e2d1707f21141cea76d47ce36c3ef"
    sha256 cellar: :any, sonoma:        "144610b7bcb76c26f88d37c94c0828d342e0ab18c6d8a1cddc23deb8597ef5d1"
    sha256 cellar: :any, ventura:       "40ca0ff2fe6a3df5805280bc815bba722d88c58d4aa009d4b81e1067f257143b"
    sha256               x86_64_linux:  "40b26fcec25cbf140ab398a4e4d1b245d3eec9771e42934b0af33973da0fe410"
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
    url "https:github.comOpenRCT2objectsreleasesdownloadv1.5.1objects.zip"
    sha256 "c6b800cbcd7b1b9c707f3657fbc5f2db9d3cfd9c2adf668accc9ddbacd7841df"
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