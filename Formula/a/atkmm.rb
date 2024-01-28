class Atkmm < Formula
  desc "Official C++ interface for the ATK accessibility toolkit library"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/atkmm/2.36/atkmm-2.36.3.tar.xz"
  sha256 "6ec264eaa0c4de0adb7202c600170bde9a7fbe4d466bfbe940eaf7faaa6c5974"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "62dd226fac2e76888483763ecc6ef017a652bde7bb98c914565c8002efe03db3"
    sha256 cellar: :any, arm64_ventura:  "3cc5b98b28dad00ca0c2caf58510534bb1181ec9a649ce4fcf1dc4c587bb7fb9"
    sha256 cellar: :any, arm64_monterey: "24dd60968bc4fea78ba832266d4a735d1bbd678f52b75bdb1df621cb4d8c8092"
    sha256 cellar: :any, sonoma:         "6454c0225d51922b4ad717b04dade8bf93b92aa26c836d77b41a55fbc41a0a14"
    sha256 cellar: :any, ventura:        "8327309298dd1743517ed04c4d8b0c7803c9619ea9139dfcbe5531f51730a639"
    sha256 cellar: :any, monterey:       "d16d833f1b2cd3ff76fd00054da59dba3413e2ce655068f62ef2c47dabe8e08b"
    sha256               x86_64_linux:   "cec181c4ae3a4be7b814e82d909f1128e5279592ff3a4ea6e7e85baebe27dbb0"
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