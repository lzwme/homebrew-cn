class Vte3 < Formula
  desc "Terminal emulator widget used by GNOME terminal"
  homepage "https://wiki.gnome.org/Apps/Terminal/VTE"
  url "https://download.gnome.org/sources/vte/0.82/vte-0.82.1.tar.xz"
  sha256 "79376d70402d271e2d38424418e1aea72357934d272e321e3906b71706a78e3a"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "37d2eb956de7a8beb0540657cf3471b96a3fa3ab6150a5d1ec86a39efaa6a213"
    sha256 arm64_sequoia: "992d26e6ec3d23cb92dabea3a4032cbcc04b0dda024f2996e0e8017de66d4324"
    sha256 arm64_sonoma:  "ac4705c0fc9400258e1f3b1c62ce43432664fa65497bb980261f03e2bc2dae07"
    sha256 sonoma:        "5f29b5f9a83e3241d4a37d298bb24dde336713a332fca3d3100f623f897230b8"
    sha256 arm64_linux:   "938c84d2152f38ecfc249997217c9fba1beb1e0d5ad98ff91e6957128f497adb"
    sha256 x86_64_linux:  "0d62a36ba16a82c878ed11625776e8c0a1b74df33589c39a2a1e0e7dbdc96fcf"
  end

  depends_on "fast_float" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "fribidi"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "graphene"
  depends_on "gtk+3"
  depends_on "gtk4"
  depends_on "icu4c@77"
  depends_on "lz4"
  depends_on "pango"
  depends_on "pcre2"
  depends_on "simdutf"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "gettext"
  end

  on_ventura :or_older do
    depends_on "llvm" => :build

    fails_with :clang do
      cause "error: 'to_chars' is unavailable: introduced in macOS 13.3"
    end
  end

  on_linux do
    depends_on "systemd"
  end

  # https://en.cppreference.com/w/cpp/compiler_support/23.html#cpp_lib_string_resize_and_overwrite_202110L
  fails_with :gcc do
    version "11"
    cause "Requires C++23 basic_string::resize_and_overwrite()"
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "meson", "setup", "build", "-Dgir=true",
                                      "-Dgtk3=true",
                                      "-Dgtk4=true",
                                      "-Dgnutls=true",
                                      "-Dvapi=true",
                                      "-D_b_symbolic_functions=false",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <vte/vte.h>

      int main(int argc, char *argv[]) {
        guint v = vte_get_major_version();
        return 0;
      }
    C
    flags = shell_output("pkgconf --cflags --libs vte-2.91").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    flags = shell_output("pkgconf --cflags --libs vte-2.91-gtk4").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end