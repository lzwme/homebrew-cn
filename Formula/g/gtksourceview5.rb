class Gtksourceview5 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/5.14/gtksourceview-5.14.0.tar.xz"
  sha256 "c40d1f7309d111f5805fec47c1fead519c4b8d506317ce5e90013ce47d65e9c6"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtksourceview[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "1009e77ffceb4849dad7d920bdf0111010513dfe50d45030598f6ba0349c7413"
    sha256 arm64_sonoma:  "2eb5dcdcf1810689c7c19ee2d581a66cd1fd6f79a6b86a8ebb3b03e406aa6250"
    sha256 arm64_ventura: "70fb65b657d878c0cf1418b87e9214c864421fc7da96124ec8c6bfa6ca9581ca"
    sha256 sonoma:        "d14deeb02a29fdc05a3c973e9de19c81445fe541dc6e5736ef7e8c9dd0b7c61c"
    sha256 ventura:       "5ad59964c36d4a9f43290fa7a70ce85ab28b466caf551025c77ec670c759c950"
    sha256 x86_64_linux:  "d9ca6c7f87088f3c50c22259fb07ba1fc5d5271a5797506c27ee9eb972165955"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build

  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "fribidi"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "pango"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %w[
      -Dintrospection=enabled
      -Dvapi=true
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtksourceview/gtksource.h>

      int main(int argc, char *argv[]) {
        gchar *text = gtk_source_utils_unescape_search_text("hello world");
        return 0;
      }
    EOS

    pkg_config_cflags = shell_output("pkg-config --cflags --libs gtksourceview-5").chomp.split
    system ENV.cc, "test.c", *pkg_config_cflags, "-o", "test"
    system "./test"
  end
end