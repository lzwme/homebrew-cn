class GnomeAutoar < Formula
  desc "GNOME library for archive handling"
  homepage "https://github.com/GNOME/gnome-autoar"
  url "https://download.gnome.org/sources/gnome-autoar/0.5/gnome-autoar-0.5.0.tar.xz"
  sha256 "70915cfbb226746a57d5c605771a01f60de317eab9bc3953f44df2712a53c836"
  license "LGPL-2.1-or-later"

  # gnome-autoar doesn't seem to follow the typical GNOME version format where
  # even-numbered minor versions are stable, so we override the default regex
  # from the `Gnome` strategy.
  livecheck do
    url :stable
    regex(/gnome-autoar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0da0169f09934c318a0f1decb03299ba64195d33181f9dfa16da820e232598d1"
    sha256 cellar: :any, arm64_sequoia: "e99101c6a2b22390917085da11c9050e389723a12582c1023b4a0c32bb3060b3"
    sha256 cellar: :any, arm64_sonoma:  "313157ef981277c416a1f54cea820c0fa739d5d71df0970fd1607cdba6693ae3"
    sha256 cellar: :any, arm64_linux:   "931eff7070123ac0ef03d34e2a7c07d14b107a7eedf745648967ed1321f8950d"
    sha256 cellar: :any, x86_64_linux:  "53f60928494fc0296cefeb6208c2b24b2ca96e3a1344f5c019f4f0d2b4e6f205"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libarchive"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    compile_gsettings_schemas
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gnome-autoar/gnome-autoar.h>

      int main(int argc, char *argv[]) {
        GType type = autoar_extractor_get_type();
        return 0;
      }
    C

    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("libarchive")/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs gnome-autoar-0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end