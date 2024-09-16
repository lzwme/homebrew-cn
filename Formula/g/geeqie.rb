class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https:www.geeqie.org"
  url "https:github.comBestImageViewergeeqiereleasesdownloadv2.4geeqie-2.4.tar.xz"
  sha256 "f2b7d1290786fdd1afec09bbe0217f327ff1ee7c80363563e8a108d03aec77da"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "ea8e701ee511f90d96b2619f7cf3860c24c1bfb8d23489e318f04937446bc467"
    sha256 cellar: :any, arm64_sonoma:  "0d6f2e915b89bb36681f60bb05485db71d0e7fcf3bd8d17866e4ecba65cccb60"
    sha256 cellar: :any, arm64_ventura: "355c39f628959783eb82caa205aa00db6710aa129c6f3bfb3fbd7e9df3579612"
    sha256 cellar: :any, sonoma:        "e6f7b06f19c5ac08785f3145006d04b856349dfcdaf7ccdd8d993807e2c7f22c"
    sha256 cellar: :any, ventura:       "2f169b84b5822523df8dbd600dd11b5abc97d5fc10f73f748da373bca444b317"
    sha256               x86_64_linux:  "b68ca64973a0923dc25e2be3a189058318a92bd878b2ce4ab91052ec6c3ca5da"
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