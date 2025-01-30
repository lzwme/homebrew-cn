class Libshumate < Formula
  desc "Shumate is a GTK toolkit providing widgets for embedded maps"
  homepage "https://gitlab.gnome.org/GNOME/libshumate"
  url "https://download.gnome.org/sources/libshumate/1.3/libshumate-1.3.2.tar.xz"
  sha256 "f8762bbc6e296d78be1f8422f56da4c40bc8d12afc7002a324172a9198eeed5c"
  license "LGPL-2.1-or-later"

  # libshumate doesn't use GNOME's "even-numbered minor is stable" version
  # scheme. This regex is the same as the one generated by the `Gnome` strategy
  # but it's necessary to avoid the related version scheme logic.
  livecheck do
    url :stable
    regex(/libshumate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "2c96971a44774a291fda60f4099c87e7d4a2eac6eb24a8e735860d454935fe27"
    sha256 cellar: :any, arm64_sonoma:  "1c975ddb47a87e7d2020c5bbed49dbccf5c147a2fc7719942c05e75cab9deccc"
    sha256 cellar: :any, arm64_ventura: "ac966c7637876a110425dff41f613ba16259472ca06343ca46adc6f880b139bc"
    sha256 cellar: :any, sonoma:        "abb49bd6f209c345b52961ba5ba3d68c47a5ef3fd319b2022a4373a54cba84fd"
    sha256 cellar: :any, ventura:       "a96c728cef1ee54fa0d44749ec6fed19f89fe0bce0d6dab42d6c4e85f60bbcb5"
    sha256               x86_64_linux:  "0a4fadfdfaf002a17cc45cd7de8a6279893bd7dedba6841e8ac2d20fc5c9b493"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "json-glib"
  depends_on "libsoup"
  depends_on "pango"
  depends_on "protobuf-c"
  depends_on "sqlite"

  uses_from_macos "gperf" => :build

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", "-Dgtk_doc=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <shumate/shumate.h>

      int main(int argc, char *argv[]) {
        char version[32];
        snprintf(version, 32, "%d.%d.%d", SHUMATE_MAJOR_VERSION, SHUMATE_MINOR_VERSION, SHUMATE_MICRO_VERSION);
        return 0;
      }
    C

    # TODO: remove this after rewriting icu-uc in `libpsl`'s pkg-config file
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig" if OS.mac?

    flags = shell_output("#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs shumate-1.0").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    # include a version check for the pkg-config files
    assert_match version.to_s, (lib/"pkgconfig/shumate-1.0.pc").read
  end
end