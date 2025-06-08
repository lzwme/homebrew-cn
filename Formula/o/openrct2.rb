class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https:openrct2.io"
  url "https:github.comOpenRCT2OpenRCT2.git",
      tag:      "v0.4.23",
      revision: "a18956c01bdb88f16427bd2e6259cdf95d3e2ada"
  license "GPL-3.0-only"
  head "https:github.comOpenRCT2OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "ad2938e838cbc8e24b2814a4381a8163014cbc042eb5756bfe5062b98ed76e80"
    sha256 cellar: :any, arm64_sonoma:  "786037c93764157227fa80f013b01ffc6dc5ef19895f62fc6eb27bb2a0507463"
    sha256 cellar: :any, sonoma:        "f7ed04b617a8f68af3b014b4bfa3ff02d5e6655db9444d33e73429122a58caa7"
    sha256               arm64_linux:   "f03ddb39bf660a981526342ddd140e260f70a07e147cbb3c372d90e56c0129b0"
    sha256               x86_64_linux:  "8a25cdd94410968759928acda9ee129648f9864b6b208622b646f0847b431148"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build

  depends_on "duktape"
  depends_on "flac"
  depends_on "freetype"
  depends_on "icu4c@77"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libzip"
  depends_on macos: :sonoma # Needs C++20 features not in Ventura
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
    url "https:github.comOpenRCT2objectsreleasesdownloadv1.6.1objects.zip"
    sha256 "6829186630e52c332b6a4847ebb936c549a522fcadaf8f5e5e4579c4c91a4450"
  end

  resource "openmusic" do
    url "https:github.comOpenRCT2OpenMusicreleasesdownloadv1.6openmusic.zip"
    sha256 "f097d3a4ccd39f7546f97db3ecb1b8be73648f53b7a7595b86cccbdc1a7557e4"
  end

  resource "opensound" do
    url "https:github.comOpenRCT2OpenSoundEffectsreleasesdownloadv1.0.5opensound.zip"
    sha256 "a952148be164c128e4fd3aea96822e5f051edd9a0b1f2c84de7f7628ce3b2e18"
  end

  def install
    # Avoid letting CMake download things during the build process.
    (buildpath"datasequence").install resource("title-sequences")
    (buildpath"dataobject").install resource("objects")
    resource("openmusic").stage do
      (buildpath"dataassetpack").install Dir["assetpack*"]
      (buildpath"dataobjectofficial").install "objectofficialmusic"
    end
    resource("opensound").stage do
      (buildpath"dataassetpack").install Dir["assetpack*"]
      (buildpath"dataobjectofficial").install "objectofficialaudio"
    end

    args = %w[
      -DWITH_TESTS=OFF
      -DDOWNLOAD_TITLE_SEQUENCES=OFF
      -DDOWNLOAD_OBJECTS=OFF
      -DDOWNLOAD_OPENMSX=OFF
      -DDOWNLOAD_OPENSFX=OFF
      -DMACOS_USE_DEPENDENCIES=OFF
      -DDISABLE_DISCORD_RPC=ON
    ]
    args << "-DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # By default, the macOS build only looks for data in app bundle Resources.
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