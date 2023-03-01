class Atkmm < Formula
  desc "Official C++ interface for the ATK accessibility toolkit library"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/atkmm/2.36/atkmm-2.36.2.tar.xz"
  sha256 "6f62dd99f746985e573605937577ccfc944368f606a71ca46342d70e1cdae079"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "00058c5e0579838d818c89064001c7389e0df4a0b92148a33cf354cc662eff24"
    sha256 cellar: :any, arm64_monterey: "84e99c11a87b16554bf8a6f3682cad91fe3538afce18acc63cda1fdb8f374f38"
    sha256 cellar: :any, arm64_big_sur:  "87202974bb4c7d0e5c7c8ecd3cf049113de10bf2a4df1c76c43effc72b1be682"
    sha256 cellar: :any, ventura:        "970d410522bd804a3a2a9c846edb941a18a2afee480338ba553461ca380d86da"
    sha256 cellar: :any, monterey:       "7f98497f232811faec23f3535d1dbb059f8eb6629c83286a72cc0073ffb09d75"
    sha256 cellar: :any, big_sur:        "c87d7feef3d12d582873fe0acf9b419dde0d218684b4d9e3a407f8279cd15e43"
    sha256 cellar: :any, catalina:       "b1fd80ccf96230f38a8faf3dd67cdf97bb359a075dbb4b48b016c08d7563e5f5"
    sha256               x86_64_linux:   "5a473139c858d0c2be2d2a97751a095c5091dafad3cd8a44ac5e56223ca506e9"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "atk"
  depends_on "glibmm"

  fails_with gcc: "5"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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
    flags = shell_output("pkg-config --cflags --libs atkmm-2.36").chomp.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end