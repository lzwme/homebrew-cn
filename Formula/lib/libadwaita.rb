class Libadwaita < Formula
  desc "Building blocks for modern adaptive GNOME applications"
  homepage "https://gnome.pages.gitlab.gnome.org/libadwaita/"
  url "https://download.gnome.org/sources/libadwaita/1.4/libadwaita-1.4.2.tar.xz"
  sha256 "33fa16754e7370c841767298b3ff5f23003ee1d2515cc2ff255e65ef3d4e8713"
  license "LGPL-2.1-or-later"

  # libadwaita doesn't use GNOME's "even-numbered minor is stable" version
  # scheme. This regex is the same as the one generated by the `Gnome` strategy
  # but it's necessary to avoid the related version scheme logic.
  livecheck do
    url :stable
    regex(/libadwaita-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "9ee825cd15be20ba5a07c46b425a2fc34a31e2d28b166b887f05256bc45dc9b6"
    sha256 arm64_ventura:  "ee3d4ff9e9780820b439675448c6cab316108108a739f73c677b8a6f687c12f3"
    sha256 arm64_monterey: "1bdb0d6456bec3664d8f51faf1f978252f93639ca8ad3c1ad06f8b67b7f546b2"
    sha256 sonoma:         "2e85f305e5db472be9697f670047fe5cc40a86c662d15e069f32efc262e41545"
    sha256 ventura:        "a9dc8302efa3a626074a004330647cd80276967072164d02d8037d796ea1a2d7"
    sha256 monterey:       "0f401fa3377d537f4943e3c99536ec4de7c98541cdcdf80bcdd96951268bada0"
    sha256 x86_64_linux:   "2c046bafeb69764a4515de7a226aeac68c2302ac9a93d19748403b5e6726bb0b"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "appstream"
  depends_on "gtk4"

  uses_from_macos "python" => :build

  def install
    system "meson", "setup", "build", "-Dtests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <adwaita.h>

      int main(int argc, char *argv[]) {
        g_autoptr (AdwApplication) app = NULL;
        app = adw_application_new ("org.example.Hello", G_APPLICATION_DEFAULT_FLAGS);
        return g_application_run (G_APPLICATION (app), argc, argv);
      }
    EOS
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libadwaita-1").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test", "--help"

    # include a version check for the pkg-config files
    assert_match version.to_s, (lib/"pkgconfig/libadwaita-1.pc").read
  end
end