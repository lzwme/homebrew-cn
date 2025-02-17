class Gtkmm3 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/3.24/gtkmm-3.24.9.tar.xz"
  sha256 "30d5bfe404571ce566a8e938c8bac17576420eb508f1e257837da63f14ad44ce"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "cf9813fbf23737aaed77daf604cbacf65182ff4309de217110225c3d3dd48b85"
    sha256 cellar: :any, arm64_sonoma:  "9e03a68ddce555fe0e879142657d4139581b1b9536cc6a70c4e0dc99fa5f3bff"
    sha256 cellar: :any, arm64_ventura: "93d2dc85c050f407a1f5d4777b3952df2a40ae9aa11300ecd380c92baf2af7ce"
    sha256 cellar: :any, sonoma:        "86c82d4acaae1dcde4b5f13cecfe4ca8d3695f109490d5cfa77a2bba3347c73b"
    sha256 cellar: :any, ventura:       "b596f92767d4d557fb310652aaefbbd0099a3b2f6e1dcc38415b28d96401e4fa"
    sha256               x86_64_linux:  "00afd547bdbe9407bbab31d5ef4c5e47543608c5810ef59bc011df9cfe210bfd"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "atkmm@2.28"
  depends_on "cairomm@1.14"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "glibmm@2.66"
  depends_on "gtk+3"
  depends_on "libsigc++@2"
  depends_on "pangomm@2.46"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <gtkmm.h>

      class MyLabel : public Gtk::Label {
        MyLabel(Glib::ustring text) : Gtk::Label(text) {}
      };
      int main(int argc, char *argv[]) {
        return 0;
      }
    CPP

    flags = shell_output("pkgconf --cflags --libs gtkmm-3.0").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end