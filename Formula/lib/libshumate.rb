class Libshumate < Formula
  desc "Shumate is a GTK toolkit providing widgets for embedded maps"
  homepage "https://gitlab.gnome.org/GNOME/libshumate"
  url "https://download.gnome.org/sources/libshumate/1.1/libshumate-1.1.3.tar.xz"
  sha256 "6b8a159ed744fdd15992411662a05cb4187fb55e185111a366e0038d2f0b3543"
  license "LGPL-2.1-or-later"

  # libshumate doesn't use GNOME's "even-numbered minor is stable" version
  # scheme. This regex is the same as the one generated by the `Gnome` strategy
  # but it's necessary to avoid the related version scheme logic.
  livecheck do
    url :stable
    regex(/libshumate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "d2b31d7dee8902f8f64878ee97fdd2cf5e198eddc7e8e1fc8d0c3e14c2524fad"
    sha256 cellar: :any, arm64_ventura:  "51df2ed5cd3c13f37e607a7d214907ba455deba04686a5f95e9d8ecbb5359feb"
    sha256 cellar: :any, arm64_monterey: "813550578363eaea1445e2c76513c080d3bff84bd397e2a2a06b633c6adf7151"
    sha256 cellar: :any, sonoma:         "5e7a0c8345f8bbd168915813f8104169f6fc26930206701b68782b29ac39d9a0"
    sha256 cellar: :any, ventura:        "39ae233ff9461501881fe54de071c48f3b66d4bcfaa728d3019aba3a3cae09e6"
    sha256 cellar: :any, monterey:       "78d53203ac1687251681abe867cca76dfd630dbddca33b987e45c7af8850a766"
    sha256               x86_64_linux:   "b05b32c948b161d63d2ae82436e9b38cae49f2b3d7dd90290fd6170373fc0c5e"
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
  depends_on "libsoup"
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