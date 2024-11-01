class Libspelling < Formula
  desc "Spellcheck library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libspelling"
  url "https://gitlab.gnome.org/GNOME/libspelling/-/archive/0.4.4/libspelling-0.4.4.tar.bz2"
  sha256 "9b2adc84b7cb964588ee55f70a8c61fea942f894a89f41af9a186c7b17abbc5a"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_sequoia: "544f99d7226d07a24a0b5c878f057f3d38f5d24ecf32a7f724be39e0ed58e2d2"
    sha256 arm64_sonoma:  "7dc5d4e683e46fd2f960ed171b9748611fce54d0921f3cdf7cb206f662bed35c"
    sha256 arm64_ventura: "6fed5f819f45aa5de2ce58bd899a551a34f264de0f36401d7103c54556c42894"
    sha256 sonoma:        "ba9c7208ff52fa9c14a33a3f25a392d9d6c423ef84b13feb04176e4e1ff6faf3"
    sha256 ventura:       "f7f40f4b3530a5e7b6fae7cf7538dbd36c25a2ad577862d372d0d0e0e2f7ddba"
    sha256 x86_64_linux:  "42e881b76bb593fd772dff4a53a348469d6bf653e274209fef15820917c1773a"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build

  depends_on "enchant"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "icu4c@76"
  depends_on "pango"

  on_macos do
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "graphene"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "sysprof"
  end

  def install
    system "meson", "setup", "build", "-Ddocs=false", "-Dsysprof=#{OS.linux?}", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libspelling.h>

      int main(int argc, char *argv[]) {
        SpellingChecker *checker = spelling_checker_get_default();
        return 0;
      }
    C

    pkg_config_cflags = shell_output("pkg-config --cflags --libs libspelling-1").chomp.split
    system ENV.cc, "test.c", *pkg_config_cflags, "-o", "test"
    system "./test"
  end
end