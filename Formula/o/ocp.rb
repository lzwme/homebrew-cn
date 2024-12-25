class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https:stian.cubic.orgproject-ocp.php"
  url "https:stian.cubic.orgocpocp-3.0.0.tar.xz"
  sha256 "0dadfbfd755eac84aa33e23b24eb158f01f674e16a28e9820ad67e2f90418483"
  license "GPL-2.0-or-later"
  head "https:github.commywave82opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "b5fdbd1aba97e89967999d2106f323a902c48fefe074bbb40738d5ed4e8a80f2"
    sha256 arm64_sonoma:  "77ca5c808c77f70fe6aec3e4325708080a4c825475833f267845291464a4a01f"
    sha256 arm64_ventura: "ff5fca2c6a9fdcd9c3023eccc1ac49e54baf3cc1d89be576ec033facdba03d19"
    sha256 sonoma:        "0ef2ae3294163b9a04fbdd5a469ca3c3fb2fd6748ce5e3970e7e22cb37e2f74d"
    sha256 ventura:       "4f218ff633330609a113e3fc26a1ef0d38c306cc09542e138e067890701f684f"
    sha256 x86_64_linux:  "fddaa7f678cca44140cdf683631fd82d3ed9470242ca044d0ad480c6bf4f0f6c"
  end

  depends_on "pkgconf" => :build
  depends_on "xa" => :build

  depends_on "ancient"
  depends_on "cjson"
  depends_on "flac"
  depends_on "freetype"
  depends_on "game-music-emu"
  depends_on "jpeg-turbo"
  depends_on "libdiscid"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "sdl2"

  uses_from_macos "bzip2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libogg"
  end

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
    depends_on "alsa-lib"
  end

  # pin to 15.0.6 to use precompiled fonts
  resource "unifont" do
    url "https:ftp.gnu.orggnuunifontunifont-15.0.06unifont-15.0.06.tar.gz"
    sha256 "36668eb1326d22e1466b94b3929beeafd10b9838bf3d41f4e5e3b52406ae69f1"
  end

  def install
    # Fix compile with newer Clang
    # upstream bug report, https:github.commywave82opencubicplayerissues121
    if DevelopmentTools.clang_build_version >= 1403
      ENV.append_to_cflags "-Wno-implicit-function-declaration -Wno-int-conversion"
    end

    ENV.deparallelize

    # Required for SDL2
    resource("unifont").stage do |r|
      cd "fontprecompiled" do
        share.install "unifont-#{r.version}.ttf" => "unifont.ttf"
        share.install "unifont_csur-#{r.version}.ttf" => "unifont_csur.ttf"
        share.install "unifont_upper-#{r.version}.ttf" => "unifont_upper.ttf"
      end
    end

    args = %W[
      --prefix=#{prefix}
      --without-x11
      --without-desktop_file_install
      --without-update-mime-database
      --without-update-desktop-database
      --with-unifontdir-ttf=#{share}
      --with-unifontdir-otf=#{share}
    ]

    system ".configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin"ocp", "--help"
  end
end