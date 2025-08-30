class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  # release info on the website might lag behind, refer to gitlab tags for latest release info
  # see discussions in https://gitlab.gnome.org/GNOME/gexiv2/-/issues/77
  url "https://download.gnome.org/sources/gexiv2/0.14/gexiv2-0.14.6.tar.xz"
  sha256 "606c28aaae7b1f3ef5c8eabe5e7dffd7c5a1c866d25b7671fb847fe287a72b8b"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_sequoia: "01cfd67bd880e207ba998a0dc1e43586a722da00d78da421ff4207468de58313"
    sha256 cellar: :any, arm64_sonoma:  "2a4dcaddbd5c21e6289eaf3b777c3bbd30a72e190efaaf074e59c42cee8c7986"
    sha256 cellar: :any, arm64_ventura: "ec5fe692958fb222140c1e467189ad659fb89a371fc5a92d570d1caacf2c0871"
    sha256 cellar: :any, sonoma:        "4f4f86c2fbd0844e47febbd013085105c29a0efd570fcb60b2108c22fac6be62"
    sha256 cellar: :any, ventura:       "8143bbdca810fbdb21a385a782ada429f4e089e16ced96561ec27ba6ee45397c"
    sha256               arm64_linux:   "638d60959198dc60f9987d7d86707b407d53e93c082ce149cd3d5f6222fb9c83"
    sha256               x86_64_linux:  "ba21188d37df77f06e4aa6cf810a2161dbd8f7e66ddb65d4f53885564bff04e6"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "pygobject3" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "vala" => :build
  depends_on "exiv2"
  depends_on "glib"

  def python3
    "python3.13"
  end

  def install
    site_packages = prefix/Language::Python.site_packages(python3)

    # Update to use c++17 when `exiv2` is updated to use c++17
    system "meson", "setup", "build", "-Dcpp_std=c++11",
                                      "-Dpython.platlibdir=#{site_packages}",
                                      "-Dpython.purelibdir=#{site_packages}",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gexiv2/gexiv2.h>
      int main() {
        GExiv2Metadata *metadata = gexiv2_metadata_new();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test",
                   "-I#{HOMEBREW_PREFIX}/include/glib-2.0",
                   "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include",
                   "-L#{lib}",
                   "-lgexiv2"
    system "./test"

    (testpath/"test.py").write <<~PYTHON
      import gi
      gi.require_version('GExiv2', '0.10')
      from gi.repository import GExiv2
      exif = GExiv2.Metadata('#{test_fixtures("test.jpg")}')
      print(exif.try_get_gps_info())
    PYTHON
    assert_equal "(longitude=0.0, latitude=0.0, altitude=0.0)\n", shell_output("#{python3} test.py")
  end
end