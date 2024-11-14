class GumboParser < Formula
  desc "C99 library for parsing HTML5"
  homepage "https://codeberg.org/gumbo-parser/gumbo-parser"
  url "https://codeberg.org/gumbo-parser/gumbo-parser/archive/0.12.2.tar.gz"
  sha256 "7515dfef24c288fe1230c7b3beef15f09289ed1ac8a926ff249495260e4a1336"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2c54b3087e6e80d194f52de2bb0f73a2f3ca4c8b1bde912a769bf8f2cfef8337"
    sha256 cellar: :any,                 arm64_sonoma:  "8a4d0f6ed73169155c7cd37d775b688349918b9e3577909867b1648a2c8a53d9"
    sha256 cellar: :any,                 arm64_ventura: "959f1601d4f72f51f3d968fed5a196c957326850e2859572632f229f7d3e5099"
    sha256 cellar: :any,                 sonoma:        "5db64b43834f929bcb3cfc43982e2881e2f4fcbfd6bcaeefd6e66a8b19cf961e"
    sha256 cellar: :any,                 ventura:       "766a7344b7da2c218aa78715bbb00187b7b8d21ec56dcd48c993cf7a9a8bac9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea0b6a6fd322f57490ed541a2ad0f1dfcac0cb20f8dfade2fb0a85126eeb2ea8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "gumbo.h"

      int main() {
        GumboOutput* output = gumbo_parse("<h1>Hello, World!</h1>");
        gumbo_destroy_output(&kGumboDefaultOptions, output);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lgumbo", "-o", "test"
    system "./test"
  end
end