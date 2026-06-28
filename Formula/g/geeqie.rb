class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://ghfast.top/https://github.com/BestImageViewer/geeqie/releases/download/v2.9/geeqie-2.9.tar.xz"
  sha256 "5f0214778112da6daf3736a6ea04c10b093ea339dcc54676435a097ef8dfcd2d"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "587eb292c7e58acc54871c03ebca1b4c0c2c8af04b23f6509739c2adf7575b47"
    sha256 cellar: :any, arm64_sequoia: "ea36a8040f397bf8cc0735af55f4fe6ac433de4e02798d3bf04ed29f94b9b69f"
    sha256 cellar: :any, arm64_sonoma:  "a95296472687a0b1f5c57f9811c61b8f268e6a9e9d776c5888ab1b2d8f60ed07"
    sha256 cellar: :any, sonoma:        "1c3cd26b926672d53dd068eebd210d72751b8c6f0a6d148774bcd8b93e57a959"
    sha256               arm64_linux:   "9e611884f28d6ab9c7ec3a9c8570096008af7aed1744bb457041950fcaf8e1e2"
    sha256               x86_64_linux:  "f986db2448ede575a3d8b55cbf973442892a9b2b772258307598cff283c078f5"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme" => :no_linkage
  depends_on "cairo"
  depends_on "djvulibre"
  depends_on "exiv2"
  depends_on "ffmpegthumbnailer"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gspell" # for spell checks support
  depends_on "gtk+3"
  depends_on "imagemagick"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libarchive"
  depends_on "libheif"
  depends_on "libraw"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "pango"
  depends_on "poppler" # for pdf support # for video thumbnails support
  depends_on "webp" # for webp support

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "python" => :build
  uses_from_macos "vim" => :build # for xxd

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "xorg-server" => :test
  end

  def install
    args = %w[-Dlua=disabled -Dyelp-build=disabled]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Geeqie 2.7 currently crashes in Linux CI when initializing the GUI stack.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    cmd = "#{bin}/geeqie --version"
    cmd = "#{Formula["xorg-server"].bin}/xvfb-run #{cmd}" if OS.linux? && ENV.exclude?("DISPLAY")
    assert_match version.to_s, shell_output(cmd)
  end
end