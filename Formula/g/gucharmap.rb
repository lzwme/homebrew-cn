class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://gitlab.gnome.org/GNOME/gucharmap/-/archive/15.1.2/gucharmap-15.1.2.tar.bz2"
  sha256 "f8580cb191d0a430513d0384b1f619a5eb8ad40dbd609d0c0f8370afa756c1fe"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "c22f7ead176bde24d19ee63dca996c0805d2b8b8a3eed4086605315673d3a9fa"
    sha256 arm64_ventura:  "36bddb28a682d518b6d931f8329c833129a484f138fc18df8ce435348e93c2c0"
    sha256 arm64_monterey: "693ab829817863ac15880d67920ad502c81672c693ff91166d4433a56171b035"
    sha256 sonoma:         "9c8c8e7df3d2376d9fa860fd78c5c0d5e4bdfa69238eb08aa925cce2e1cb2217"
    sha256 ventura:        "a112495d47384cc0bfca2f7be8515951292dbc3a8a01da73bc67b1b8a2217cbb"
    sha256 monterey:       "259e7121667d30b0e3ecd0615a92b1d2039796ee34a9087dbad965fadb9dd766"
    sha256 x86_64_linux:   "5983b9f46d861e8d71c69c7874d0b4438b14d4213081a194e12e94bda2c58be2"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gtk+3"

  on_linux do
    depends_on "gettext" => :build
  end

  resource "ucd" do
    url "https://www.unicode.org/Public/15.1.0/ucd/UCD.zip"
    sha256 "cb1c663d053926500cd501229736045752713a066bd75802098598b7a7056177"
  end

  resource "unihan" do
    url "https://www.unicode.org/Public/15.1.0/ucd/Unihan.zip", using: :nounzip
    sha256 "a0226610e324bcf784ac380e11f4cbf533ee1e6b3d028b0991bf8c0dc3f85853"
  end

  def install
    ENV["DESTDIR"] = "/"
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    (buildpath/"unicode").install resource("ucd")
    (buildpath/"unicode").install resource("unihan")

    # ERROR: Assert failed: -Wl,-Bsymbolic-functions is required but not supported
    inreplace "meson.build", "'-Wl,-Bsymbolic-functions'", "" if OS.mac?

    system "meson", *std_meson_args, "build", "-Ducd_path=#{buildpath}/unicode"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/gucharmap", "--version"
  end
end