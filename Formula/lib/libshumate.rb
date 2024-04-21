class Libshumate < Formula
  desc "Shumate is a GTK toolkit providing widgets for embedded maps"
  homepage "https://gitlab.gnome.org/GNOME/libshumate"
  url "https://download.gnome.org/sources/libshumate/1.2/libshumate-1.2.1.tar.xz"
  sha256 "1105ee077e2147f2a039cddfa616fa5cb9438883dd940427e11699dcd6549c11"
  license "LGPL-2.1-or-later"

  # libshumate doesn't use GNOME's "even-numbered minor is stable" version
  # scheme. This regex is the same as the one generated by the `Gnome` strategy
  # but it's necessary to avoid the related version scheme logic.
  livecheck do
    url :stable
    regex(/libshumate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "a6e17d2b3a62dc36dd3f3e1d1a17744e334faef8cbc7477c3211a63cf4bacb8c"
    sha256 cellar: :any, arm64_ventura:  "93c3c14fc81e14cf799f7c14c713408cb32082f0d1b1720ba45b8bc8a76a5678"
    sha256 cellar: :any, arm64_monterey: "4c5ff1c1c8d000ec006ffdba57561d1553807b40a92b78666ab627a792433955"
    sha256               x86_64_linux:   "231921ec6cd7e37320e3adff0b6994acdd9fa46e68c1bb6e0975f3db5bbee656"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build

  depends_on "cmake"
  depends_on "gi-docgen"
  depends_on "gtk4"
  depends_on "json-glib"
  depends_on "libsoup"
  depends_on "protobuf-c"

  uses_from_macos "gperf"
  uses_from_macos "icu4c"
  uses_from_macos "sqlite"

  def install
    system "meson", "setup", "build", "-Dgtk_doc=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <shumate/shumate.h>

      int main(int argc, char *argv[]) {
        char version[32];
        snprintf(version, 32, "%d.%d.%d", SHUMATE_MAJOR_VERSION, SHUMATE_MINOR_VERSION, SHUMATE_MICRO_VERSION);
        return 0;
      }
    EOS
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig" if OS.mac?
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs shumate-1.0").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    # include a version check for the pkg-config files
    assert_match version.to_s, (lib/"pkgconfig/shumate-1.0.pc").read
  end
end