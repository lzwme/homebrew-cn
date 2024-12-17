class GumboParser < Formula
  desc "C99 library for parsing HTML5"
  homepage "https://codeberg.org/gumbo-parser/gumbo-parser"
  url "https://codeberg.org/gumbo-parser/gumbo-parser/archive/0.12.3.tar.gz"
  sha256 "a446a2856a5dfcc544f466fdcca4c953096a1895b9a7953eed903bd017c34132"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6a7ba9e89ebbce28a42a7c66c9990ef70e85fcd1c62bb7e5798b1af167fc7be5"
    sha256 cellar: :any,                 arm64_sonoma:  "1d02708ad57249f01c37e197fff9950957e908b7f04806a06a693b96aae15072"
    sha256 cellar: :any,                 arm64_ventura: "472bc70dee20d83e6741e4ca384e41e9fa0b2acf9010816e3f61119644efa57a"
    sha256 cellar: :any,                 sonoma:        "e1140a89f555601c12637478396470ca2585bdfd89f93092a46e18b7ecac3a5e"
    sha256 cellar: :any,                 ventura:       "3084fd4fd0da35f5689f8895d98ebe6e8ea602e40941ce16901f042183308095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bc67ecbf49ca6bde45cdf0cf7b8532052254c97785f731f84753759cb267f5d"
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