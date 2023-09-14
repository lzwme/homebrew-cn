class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://gitlab.gnome.org/GNOME/gucharmap/-/archive/15.1.0/gucharmap-15.1.0.tar.bz2"
  sha256 "8d9b4a5fb2179dcd483490a4fca567aec23b9ee96d0bc39b3fe73a3152feab00"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "26161278577f655791632086bb4c6304ebe4a11a448f3efc7d0db22d0b502e1f"
    sha256 arm64_monterey: "c5f3d1cb5397356fe69c0586c43501d808ec42835e31e463967e5b3f82414ced"
    sha256 arm64_big_sur:  "3d7a8fe835277d8599de6396e9f20bd170f677d89f4501844786e894228c7647"
    sha256 ventura:        "6d7c188c7dc15a945d5b9ac4f553d8ee88412302af0ce7d72e948162f4aeee3f"
    sha256 monterey:       "4ae7d0d442aa47ebccd63e7f106ae4eb307dbfd130f649ae1eda3980e7f531cc"
    sha256 big_sur:        "6d6908181e251152af2335931f430c1548f4136a0e85eb645f7ecf974a47fe4a"
    sha256 x86_64_linux:   "8f21f6813d186b7ef009d3d28034a1fdb333ad2729ad53d059794c582fa5f928"
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