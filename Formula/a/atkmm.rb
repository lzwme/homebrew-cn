class Atkmm < Formula
  desc "Official C++ interface for the ATK accessibility toolkit library"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/atkmm/2.36/atkmm-2.36.2.tar.xz"
  sha256 "6f62dd99f746985e573605937577ccfc944368f606a71ca46342d70e1cdae079"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "2b26464c452d497c5f7733139178a5af27cc7bfe19887c1256a1ca062847fdc3"
    sha256 cellar: :any, arm64_ventura:  "a8c0fa46900a62e555167c9e64daaaf99a23c309163c97628ab388c82f48dc94"
    sha256 cellar: :any, arm64_monterey: "18c5366998778655f3b3e763112c25bd9ced8a6d39330259934c7d1a05860ee9"
    sha256 cellar: :any, sonoma:         "cb5c29c19c8472bc5ae82df6aa9c8772c4008c69e677f902dc86b913129807aa"
    sha256 cellar: :any, ventura:        "6c024b94531bc97c6b6a278a9b16dd23a263887ffc232012e7d586037a005e49"
    sha256 cellar: :any, monterey:       "70d07f74ed39fc547ca95d8ef3d1f0e448719ace0299646b0fd4e58f235032d7"
    sha256               x86_64_linux:   "f4418a0fe87c9891115c4e4093bb6b14639e7255fc0c0e23d94401e9c99c7dcf"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "at-spi2-core"
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