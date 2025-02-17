class GlibmmAT266 < Formula
  desc "C++ interface to glib"
  homepage "https://gtkmm.gnome.org/"
  url "https://download.gnome.org/sources/glibmm/2.66/glibmm-2.66.7.tar.xz"
  sha256 "fe02c1e5f5825940d82b56b6ec31a12c06c05c1583cfe62f934d0763e1e542b3"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.gnome.org/sources/glibmm/2.66/"
    regex(/href=.*?glibmm[._-]v?(2\.66(?:\.\d+)+)\.t/i)
    strategy :page_match
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "67a6951ce935397adedefb3e6ffdc816c542620ad3ced041182efcf9f8bbcede"
    sha256 cellar: :any, arm64_sonoma:  "cdf2d5c9409820fbeff140b1c3e92ecd487c0062cdab4b368024ac33e76257af"
    sha256 cellar: :any, arm64_ventura: "bba1b6926d6d5042543a9e6be57c2dac83b98a8a3107e61d19cb4a592d150352"
    sha256 cellar: :any, sonoma:        "bafe81da0b2a2fdd2bea4963ef0a43c0f697e7b017b48b11e39c0400c32440ac"
    sha256 cellar: :any, ventura:       "1ece8762552236ebbf6372948b183fb23eea5e20e2bce0a97ae7551f8d951884"
    sha256               x86_64_linux:  "f6809b377f3b8e34b75f0f0166371ee29903fbcb1ad833dddc552ddf125a5ea7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "glib"
  depends_on "libsigc++@2"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <glibmm.h>

      int main(int argc, char *argv[])
      {
         Glib::ustring my_string("testing");
         return 0;
      }
    CPP

    flags = shell_output("pkgconf --cflags --libs glibmm-2.4").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end