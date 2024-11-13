class Gitg < Formula
  desc "GNOME GUI client to view git repositories"
  homepage "https://wiki.gnome.org/Apps/Gitg"
  url "https://download.gnome.org/sources/gitg/44/gitg-44.tar.xz"
  sha256 "342a31684dab9671cd341bd3e3ce665adcee0460c2a081ddc493cdbc03132530"
  license "GPL-2.0-or-later"
  revision 4

  livecheck do
    url :stable
    regex(/gitg[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "4a4166491817b8eadee5a1bd6774f5b23516f54661aa120d5ba9f84cb49466b6"
    sha256 arm64_sonoma:  "2c01486f3f82a1b9eb7ba8ff00d8ee5207671f8353f79d49d2c62b1da208a3f6"
    sha256 arm64_ventura: "1790af181f11994bd36b965b0ff044a6b109d98f76dde3ca91fc50a6580cc545"
    sha256 sonoma:        "b4cd70bb9e6834bf8fa1087da17ffb4c2d689ed0fab8bdb49ac06eb39558e33b"
    sha256 ventura:       "391b2a3164edbca47ea114e6877114cab7e7d2837830f60570cb4431d28e72f7"
    sha256 x86_64_linux:  "b78db1a31d523be329532fcb6e861e4420d3d1918239d7a325651d2d98e92c5c"
  end

  depends_on "gettext" => :build # for `msgfmt`
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gpgme"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "hicolor-icon-theme"
  depends_on "json-glib"
  depends_on "libdazzle"
  depends_on "libgee"
  depends_on "libgit2"
  depends_on "libgit2-glib"
  depends_on "libhandy"
  depends_on "libpeas@1"
  depends_on "libsecret"
  depends_on "pango"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Work-around for build issue with Xcode 15.3: https://gitlab.gnome.org/GNOME/gitg/-/issues/465
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    ENV["DESTDIR"] = "/"
    system "meson", "setup", "build", "-Dpython=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # Disable this part of test on Linux because display is not available.
    assert_match version.to_s, shell_output("#{bin}/gitg --version") if OS.mac?

    (testpath/"test.c").write <<~C
      #include <libgitg/libgitg.h>

      int main(int argc, char *argv[]) {
        GType gtype = gitg_stage_status_file_get_type();
        return 0;
      }
    C

    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libgit2@1.7"].opt_lib/"pkgconfig"
    flags = shell_output("pkg-config --cflags --libs libgitg-1.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end