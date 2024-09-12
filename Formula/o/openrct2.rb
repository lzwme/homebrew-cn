class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https:openrct2.io"
  url "https:github.comOpenRCT2OpenRCT2.git",
      tag:      "v0.4.14",
      revision: "18492da2296ac6355844c7e53a56e584ee637b6f"
  license "GPL-3.0-only"
  head "https:github.comOpenRCT2OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "34204e23e3a7b69c46e24fdcd2597693e6da30fa80d5f90543559c5ca74186ee"
    sha256 cellar: :any, arm64_sonoma:   "b41b0ba5b2eb5fd41dc9abc0591e6de7d5c6a7eae6be118da900ea72d2cd7744"
    sha256 cellar: :any, arm64_ventura:  "8c5e2a60bae7c6d5293c7da19ef07be22ff94ecc8fabdca8396ce303b3e8d142"
    sha256 cellar: :any, arm64_monterey: "5728bb8c4c3c6cbbebc7911ead6ade7725f3396cc3f67e8015554b492d805bc9"
    sha256 cellar: :any, sonoma:         "7e808aa325bf51b3cae1397e50a503491a8e145b486faeab3aecec8a43e7a5ff"
    sha256 cellar: :any, ventura:        "78aca1947ee090961b372b1a103cfa3aa4b2114a75f48d696ebe1d1e6d4c27ed"
    sha256 cellar: :any, monterey:       "6622e420b724a76b97e7d967bfb500bed008f53649959b7f44fa03a1d44bc5bf"
    sha256               x86_64_linux:   "5878fad625d3f7a61f0e082b20c0634dd766fac1d6b70794993d5256a1d159f8"
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
    url "https:github.comOpenRCT2objectsreleasesdownloadv1.4.7objects.zip"
    sha256 "003c7d8a68a2461ac27204a361ffe6eab66e3aff262755b9830c97ce36d6fb65"
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