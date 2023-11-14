class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://ghproxy.com/https://github.com/BestImageViewer/geeqie/releases/download/v2.1/geeqie-2.1.tar.xz"
  sha256 "d0511b7840169d37e457880d1ab2a787c52b609a0ab8fa1a8a391e841fdd2dde"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "82aab3a3043bfb4cb20b3a9dfd4712962c9a9ef29008489b7eed1621f9f97c93"
    sha256 cellar: :any, arm64_ventura:  "13811bfe1db32a6382981a9e96a4cad44d841c27cd14041d8d68679e49ce1309"
    sha256 cellar: :any, arm64_monterey: "7b67b06b1f1ac205a892aad310dc953671736f631fcc580ab4d6981a34ac0fb7"
    sha256 cellar: :any, sonoma:         "0d7c4d29e6da9097537841dec76c651e116707e02fb0ea2c6ce6d6a65fb07495"
    sha256 cellar: :any, ventura:        "8d30e3c9192385c314cab258cdf844ed778c4a64ddb92aff58d4811c4f1bad7b"
    sha256 cellar: :any, monterey:       "36f6fbe9f4ecbf8c5585e64a4dc656d6033143b7efba9a8ec2ceeb77b566ec58"
    sha256               x86_64_linux:   "6870d6da92fc7dadef99578d19216e5df2f32279b60f5296a602af62001c9c4e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pandoc" => :build # for README.html
  depends_on "pkg-config" => :build
  depends_on "yelp-tools" => :build # for help files

  depends_on "adwaita-icon-theme"
  depends_on "atk"
  depends_on "cairo"
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
  depends_on "libarchive"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "little-cms2"
  depends_on "pango"
  depends_on "poppler" # for pdf support # for video thumbnails support
  depends_on "webp-pixbuf-loader" # for webp support

  uses_from_macos "python" => :build
  uses_from_macos "vim" => :build # for xxd

  def install
    system "meson", "setup", "build", "-Dlua=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Disable test on Linux because geeqie cannot run without a display.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"geeqie", "--version"
  end
end