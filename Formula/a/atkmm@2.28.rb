class AtkmmAT228 < Formula
  desc "Official C++ interface for the ATK accessibility toolkit library"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/atkmm/2.28/atkmm-2.28.3.tar.xz"
  sha256 "7c2088b486a909be8da2b18304e56c5f90884d1343c8da7367ea5cd3258b9969"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/atkmm-(2\.28(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "5a581861d6bb55bf9d28243cd840de350c30b849aec3603504dfcc2c71dfb951"
    sha256 cellar: :any, arm64_ventura:  "4d8908bd0150a0b55e0cb5e326b605bf1193c8e9d0850254ee44bbd71424498c"
    sha256 cellar: :any, arm64_monterey: "2feda909595a65e5b4ca13cf6ed7118468e574bdbb89c8f3612d1925ca4ce4ad"
    sha256 cellar: :any, sonoma:         "7ad0339a62ca82729c825de625993d412f70aa336f46b960346ee262e25f00a9"
    sha256 cellar: :any, ventura:        "17a4dd2668827e83301fdb66c484a31b114ef58ea2768f861298ec5d35f92e9d"
    sha256 cellar: :any, monterey:       "0fbcc6e6b2afd35ac29a957a7ddc5bac274910af2ae2deb9d2661906f41c60ce"
    sha256               x86_64_linux:   "fe41ce9bb29de1d598e38f0e06cca673b3703561108ebaa665fcaab73f368ad3"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "at-spi2-core"
  depends_on "glibmm@2.66"

  def install
    ENV.cxx11
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <atkmm/init.h>

      int main(int argc, char *argv[])
      {
         Atk::init();
         return 0;
      }
    EOS
    atk = Formula["at-spi2-core"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm@2.66"]
    libsigcxx = Formula["libsigc++@2"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/glibmm-2.4
      -I#{glibmm.opt_lib}/glibmm-2.4/include
      -I#{include}/atkmm-1.6
      -I#{lib}/atkmm-1.6/include
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -L#{atk.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -latk-1.0
      -latkmm-1.6
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lsigc-2.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end