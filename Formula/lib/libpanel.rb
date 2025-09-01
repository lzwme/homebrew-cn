class Libpanel < Formula
  desc "Dock/panel library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libpanel"
  url "https://download.gnome.org/sources/libpanel/1.10/libpanel-1.10.1.tar.xz"
  sha256 "936bbe96dfb383556482120fddd4533a52d2f49303328cb694861606492445eb"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "53d48954d182ec2151e80942213a0b822f9d5521452862b0e264af807dff5e23"
    sha256 arm64_sonoma:  "0bb84dd4e71049fdfddbbde247eb786348cf202863fb166c3b6ade105abdf1cc"
    sha256 arm64_ventura: "2bf71b61f12b423faaa2f9ebac2fc05f78512bb3a7471e2d4c58f9f40146bab1"
    sha256 sonoma:        "ee5e56ee91e80ebbf9487d3d3a24a7d26473825e24dc68ba4311e7b1348ff88c"
    sha256 ventura:       "2d14fb2f8bd8b0d30aedfe2624ef59386aa900271077e72ef0ac427eed2e2a5c"
    sha256 arm64_linux:   "a5f53b2ab540343b1c316e3aac5f4961664dc7cc237bf300ae70c96911e14d34"
    sha256 x86_64_linux:  "355a72cc7c5d47f710ce581cbf83f618f3579767927c2a2cf0f6894370cd3b74"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "cairo"
  depends_on "gi-docgen"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "libadwaita"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", "-Ddocs=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libpanel.h>

      int main(int argc, char *argv[]) {
        uint major = panel_get_major_version();
        return 0;
      }
    C
    flags = shell_output("#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs libpanel-1").strip.split
    flags += shell_output("#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs libadwaita-1").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    # include a version check for the pkg-config files
    assert_match version.to_s, (lib/"pkgconfig/libpanel-1.pc").read
  end
end