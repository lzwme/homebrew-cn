class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https:www.geeqie.org"
  url "https:github.comBestImageViewergeeqiereleasesdownloadv2.1geeqie-2.1.tar.xz"
  sha256 "d0511b7840169d37e457880d1ab2a787c52b609a0ab8fa1a8a391e841fdd2dde"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "3d7ae1d94cef077ebe54e7fa3d6f167a90f6e6b535e7f9ac6242c0ad32e16de4"
    sha256 cellar: :any, arm64_ventura:  "f93422f6e30ee5841aa7c1b2d1a812e2a8d62196c2cbaaf8ad8c27f7ad5ec53c"
    sha256 cellar: :any, arm64_monterey: "f942a659c5c97508bb87f3e5dc6ec3ede4412799063314e0b8ca76d18c667bf2"
    sha256 cellar: :any, sonoma:         "b6ca6e29b80b895f0dcf3b9a2e7dd737190ca0a9bf506c43818391be06a03e4f"
    sha256 cellar: :any, ventura:        "69d4a5a09166f1fcc40aa8a6b7b73166723614a5c5d5d7a82aaeb6f30efdf2fb"
    sha256 cellar: :any, monterey:       "e2334655057bbd7bdd512cc3f391ae7263b109b3d1d10b7b304f3fc89b0530ba"
    sha256               x86_64_linux:   "ff872a4a1ede2ca7d15b0e09d521255a48ded1b536ab71e90de2c96df93f01b2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pandoc" => :build # for README.html
  depends_on "pkg-config" => :build
  depends_on "yelp-tools" => :build # for help files

  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
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

    system bin"geeqie", "--version"
  end
end