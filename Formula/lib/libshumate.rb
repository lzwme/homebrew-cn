class Libshumate < Formula
  desc "Shumate is a GTK toolkit providing widgets for embedded maps"
  homepage "https://gitlab.gnome.org/GNOME/libshumate"
  url "https://download.gnome.org/sources/libshumate/1.2/libshumate-1.2.0.tar.xz"
  sha256 "4f8413a707cd00f84cee39ca49f58c48fc436f008ea80d6532ac37dafd0ba96b"
  license "LGPL-2.1-or-later"

  # libshumate doesn't use GNOME's "even-numbered minor is stable" version
  # scheme. This regex is the same as the one generated by the `Gnome` strategy
  # but it's necessary to avoid the related version scheme logic.
  livecheck do
    url :stable
    regex(/libshumate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "c38ecbc6ee0e0bdf878ea2c6cff3d0ebbc4fd6554ca61eca186dd1fb02d0f328"
    sha256 cellar: :any, arm64_ventura:  "57c92eb784a63a9543b0c94c7d7c17e20cca8d7d2190e915b354bd0d6de8b624"
    sha256 cellar: :any, arm64_monterey: "2f9673832653c0cc845b2e5804a8500dbbe443927d44225cdf12665f79702c10"
    sha256 cellar: :any, sonoma:         "0053a3c763ddf8411c5af3271aa7056e977140b573bf86211a2b18e5f3432a60"
    sha256 cellar: :any, ventura:        "719f38ecb44260efcaa2a1b089e447b8db19696dfde6c6b539c0c13f1b3b9444"
    sha256 cellar: :any, monterey:       "4dcfd74e0582bbdd0c1392b76d1d7b9fe33ecc45a8069104ba451afdbd087f48"
    sha256               x86_64_linux:   "daf227d13db0b34ac05e9e217ad280400f4fee0ef9e3ba98d13679ab0c5f3ca3"
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