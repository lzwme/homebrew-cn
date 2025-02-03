class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https:openrct2.io"
  url "https:github.comOpenRCT2OpenRCT2.git",
      tag:      "v0.4.19",
      revision: "088081dae628046b1f35db47790b992a3cc38dcc"
  license "GPL-3.0-only"
  head "https:github.comOpenRCT2OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "4efd3f3ba4ea0e9f978b3e54bc86bc2bcd252d84031ecb6a585c5f9c6a648655"
    sha256 cellar: :any, arm64_sonoma:  "9ce31d4e4a5fa8a8c786910be4049dbd83160c188f5131b29c2e7d59831c4788"
    sha256 cellar: :any, arm64_ventura: "90f2a6ab79ccd73a2335384d2452361d4064322f4d5380916413ed6b4f4c20e7"
    sha256 cellar: :any, sonoma:        "3e6912d47cccfb7442c67e083bcd46b7e19a02a510066aa81c9aa59de6a202de"
    sha256 cellar: :any, ventura:       "3be4d726c9f09fe3edc26d6b72d0bbc81494c483bca2cff3f5245d1eec766056"
    sha256               x86_64_linux:  "ba6c20ed9f6a5ba98636345c0c65a9752603258c1bde82fa09d3acb069bfb2f6"
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