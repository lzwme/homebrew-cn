class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https:openrct2.io"
  url "https:github.comOpenRCT2OpenRCT2.git",
      tag:      "v0.4.7",
      revision: "0e8d46ea7cfdb2118435d1735967a359f936dbea"
  license "GPL-3.0-only"
  head "https:github.comOpenRCT2OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "224c1aedbe7ec587b098099b310a6c7b87d1566b72f0251df8d30f3f372e1e33"
    sha256 cellar: :any, arm64_ventura:  "0a19ebccb4db1bda27c0187a5fd871178fd66703e103ea11a204b6a85d7c9849"
    sha256 cellar: :any, arm64_monterey: "6707289e681cc7af50156733f369ec25ec60652e205c2a375c17a7cce31afc26"
    sha256 cellar: :any, sonoma:         "cb753f23b920b7950680fe9197de8c1f87b94925c546d706099ccf244ee21bec"
    sha256 cellar: :any, ventura:        "b34bc7ad6db70c411d36f28070264dcb3154dda0b6628639030fdaf09ecbcacf"
    sha256 cellar: :any, monterey:       "4e2b2bceec41eea78415b617b48cba89b9af1d1b8954e0683dbcc7624f91cf63"
    sha256               x86_64_linux:   "d989b4c0f5cbbcdcf954188e5bf2f698a65c08e5f9a93f9725b781d798910b2e"
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
    url "https:github.comOpenRCT2objectsreleasesdownloadv1.3.13objects.zip"
    sha256 "0711779d69778652d4430d4173903e2444673be374b0ed78c797b5636349b968"
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