class Libadwaita < Formula
  desc "Building blocks for modern adaptive GNOME applications"
  homepage "https://gnome.pages.gitlab.gnome.org/libadwaita/"
  url "https://download.gnome.org/sources/libadwaita/1.6/libadwaita-1.6.3.tar.xz"
  sha256 "c88d4516edd1e0fc61be925f414efc340e149171756064473a082b6ae9a5dc00"
  license "LGPL-2.1-or-later"

  # libadwaita doesn't use GNOME's "even-numbered minor is stable" version
  # scheme. This regex is the same as the one generated by the `Gnome` strategy
  # but it's necessary to avoid the related version scheme logic.
  livecheck do
    url :stable
    regex(/libadwaita-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "d19a8a59ff30b6416d24e33f4723831179f437a394243a10716120af1729ec3e"
    sha256 arm64_sonoma:  "835d589868ffb17c9ceea1ee4bd149615620109c71e87dcfdb4d28853de6fb7f"
    sha256 arm64_ventura: "4e54928ffc1309940bec37af002e0efe3aa4ffe0b73a4be9dce226015b017232"
    sha256 sonoma:        "94cfcf6ccb70e2d3415d92d59e80acb0445e92f8fbb740b86ff9932270e319be"
    sha256 ventura:       "965a0bdaf0ca1b69a95712c6e834b269ed28b5d6b2009d42977ae842947cebfd"
    sha256 x86_64_linux:  "81251bc1080ef301253096e4a4ce9c26d6b2039e32c69b61ec766e0b75fa4d3a"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "sassc" => :build
  depends_on "vala" => :build

  depends_on "appstream"
  depends_on "fribidi"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "libsass"
  depends_on "pango"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", "-Dtests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <adwaita.h>

      int main(int argc, char *argv[]) {
        g_autoptr (AdwApplication) app = NULL;
        app = adw_application_new ("org.example.Hello", G_APPLICATION_DEFAULT_FLAGS);
        return g_application_run (G_APPLICATION (app), argc, argv);
      }
    C
    flags = shell_output("#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs libadwaita-1").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test", "--help"

    # include a version check for the pkg-config files
    assert_match version.to_s, (lib/"pkgconfig/libadwaita-1.pc").read
  end
end