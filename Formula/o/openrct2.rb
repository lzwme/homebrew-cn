class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https:openrct2.io"
  url "https:github.comOpenRCT2OpenRCT2.git",
      tag:      "v0.4.15",
      revision: "c7c8fad822d10e7fbec26eeefbf2e552a02b8ea9"
  license "GPL-3.0-only"
  revision 2
  head "https:github.comOpenRCT2OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "3cca43057b9ae4952cef66529713990b55cb9ebc5662e515819e0ce2b76f6eee"
    sha256 cellar: :any, arm64_sonoma:  "c727a789409d3e0e7a7a940a4db505242a57ead1dcbd797c958220456ca3d209"
    sha256 cellar: :any, arm64_ventura: "ad217b38e23da7438abbcd3d1c8c79bf1b76b65312a78f9bc0b0e6be464f1442"
    sha256 cellar: :any, sonoma:        "860dd18528eb5b9507bc0c67969e4f2cf7d995560351429ed5200a1ca93a9c1c"
    sha256 cellar: :any, ventura:       "83550e0cccfa664b7ce804f61d0e172576819c6c3b3b00d1527984352aa8d972"
    sha256               x86_64_linux:  "70319a648bd7b22958b4978fddbbd7600f948e05f53d8938652686952b4d28c2"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkg-config" => :build

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