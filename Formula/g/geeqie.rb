class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https:www.geeqie.org"
  url "https:github.comBestImageViewergeeqiereleasesdownloadv2.4geeqie-2.4.tar.xz"
  sha256 "f2b7d1290786fdd1afec09bbe0217f327ff1ee7c80363563e8a108d03aec77da"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "41024748e3bee25351bf48e34986cfabfd6ce5da1c2b3e6f14d24bc7fec7ce8f"
    sha256 cellar: :any, arm64_sonoma:  "7362bdaf4e6cb325774b6e5467605ad853f8a8b3a14672c65c4168de86432495"
    sha256 cellar: :any, arm64_ventura: "072d76f8613a395dfb817705b714fecee996dc1ca9933790c14a011894316e78"
    sha256 cellar: :any, sonoma:        "0ba3ff0ac62dd38be5f2fdc8b3e3d28c65145191c9b29002d69d76730d8afbbf"
    sha256 cellar: :any, ventura:       "678292a55f4abb22bffed6fee69392b1f2ae0162fccd25fefdace3b9bb851ce2"
    sha256               x86_64_linux:  "c3bd0c59f8dbb8cdd87058ccd23321eae2c797c5416ec47271135973c8b34f89"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pandoc" => :build # for README.html
  depends_on "pkg-config" => :build
  depends_on "yelp-tools" => :build # for help files

  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "djvulibre"
  depends_on "evince" # for print preview support
  depends_on "exiv2"
  depends_on "ffmpegthumbnailer"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gspell" # for spell checks support
  depends_on "gtk+3"
  depends_on "imagemagick"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libarchive"
  depends_on "libheif"
  depends_on "libraw"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "pango"
  depends_on "poppler" # for pdf support # for video thumbnails support
  depends_on "webp"
  depends_on "webp-pixbuf-loader" # for webp support

  uses_from_macos "python" => :build
  uses_from_macos "vim" => :build # for xxd

  on_macos do
    depends_on "enchant"
    depends_on "harfbuzz"
  end

  def install
    system "meson", "setup", "build", "-Dlua=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Disable test on Linux because geeqie cannot run without a display.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin"geeqie", "--version"
  end
end