class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.118.tar.xz"
  sha256 "c3febe923e225c2a58f952689a89bb1db956788bfecb18a7eff6fc94da9e2469"
  license "LGPL-3.0-or-later"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/babl/0.1/"
    regex(/href=.*?babl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "87ecf025f36ec00b46d6e77269793b00fac96c86000654ea8f9d4703c222cd39"
    sha256 arm64_sequoia: "bb190c58dd490a09ff191cee454152b7b0db0817d4f2db7f3c79e45f072a6be1"
    sha256 arm64_sonoma:  "ad547a50d9712d7305bd0a30081b35a6f4a0b5ebfb91237e26be5efc1c2e0409"
    sha256 sonoma:        "a2ab5694cf2a7ac3df3b1a5d6eddab69f28dbba0a5c41a52372efe94a0f6c053"
    sha256 arm64_linux:   "fcabab13bc7fe4c134254b0cd89ee57277209d1f158cd06f1362abe231ff2780"
    sha256 x86_64_linux:  "c77be467ca188c99bb4863463603cac4ca5fb3cd375d725f4d4c3df7a0a50c65"
  end

  depends_on "glib" => :build # to add to PKG_CONFIG_PATH for gobject-introspection
  depends_on "gobject-introspection" => [:build, :test]
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pcre2" => :build # to add to PKG_CONFIG_PATH for glib
  depends_on "pkgconf" => :build
  depends_on "vala" => :build
  depends_on "little-cms2"

  uses_from_macos "libffi" => :build # to add to PKG_CONFIG_PATH for glib

  on_linux do
    depends_on "util-linux" => :build # to add to PKG_CONFIG_PATH for glib
  end

  def install
    system "meson", "setup", "build", "-Dwith-docs=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <babl/babl.h>
      int main() {
        babl_init();
        const Babl *srgb = babl_format ("R'G'B' u8");
        const Babl *lab  = babl_format ("CIE Lab float");
        const Babl *rgb_to_lab_fish = babl_fish (srgb, lab);
        babl_exit();
        return 0;
      }
    C
    system ENV.cc, "-I#{include}/babl-0.1", testpath/"test.c", "-L#{lib}", "-lbabl-0.1", "-o", "test"
    system testpath/"test"

    system Formula["gobject-introspection"].opt_bin/"g-ir-inspect", "--print-typelibs", "--print-shlibs", "Babl"
  end
end