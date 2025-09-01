class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  # release info on the website might lag behind, refer to gitlab tags for latest release info
  # see discussions in https://gitlab.gnome.org/GNOME/gexiv2/-/issues/77
  url "https://download.gnome.org/sources/gexiv2/0.14/gexiv2-0.14.6.tar.xz"
  sha256 "606c28aaae7b1f3ef5c8eabe5e7dffd7c5a1c866d25b7671fb847fe287a72b8b"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_sequoia: "ae51c1b56109208f358e343b30e5c6231e91c67c7b959f271892167eade57c4c"
    sha256 cellar: :any, arm64_sonoma:  "75dfdacca4ec507937e922bd122f72a18241afe1a9fbbbf79008397426beab1a"
    sha256 cellar: :any, arm64_ventura: "d69586756a37baad669f6f5997a63240480cb0e9605974110a8e18516b9c44c9"
    sha256 cellar: :any, sonoma:        "40cb42460feab01cfe2fe71eecb4acdcf13bf2392b954db3fac68f6f2cb0bc57"
    sha256 cellar: :any, ventura:       "efe79561c6cf589730b5e172bee34b4be91dba61f639c7ecb2c44d155d8ec7d8"
    sha256               arm64_linux:   "f977d9a3fb4262fe81153ed467be05b5f31f84cfcf80f2cab6a447ce25ede135"
    sha256               x86_64_linux:  "bbff72e50cf37058862c9292a4b660da7f2846421c00d20665460afe26b6bf3a"
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