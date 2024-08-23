class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https:github.comlibplctaglibplctag"
  url "https:github.comlibplctaglibplctagarchiverefstagsv2.6.2.tar.gz"
  sha256 "3f8f10031a143a9f2dd8bc4dec5c29f30ec44d886350fede4ccb19ddc24a8324"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ad26469fbf96790a3c93a09b0e2b2a34b79f961bded06117fe76df0dfcd7d284"
    sha256 cellar: :any,                 arm64_ventura:  "46cee404b06900051da101a1e1bb412b9f033d504637f8a7646483c70bf26d3d"
    sha256 cellar: :any,                 arm64_monterey: "e41238e6b0b938e29c86d5a388771fe24d11451aca9743f805ca530231219219"
    sha256 cellar: :any,                 sonoma:         "346d7f72bfba8c099c998b5147d6bea4057442ef7363a29bdf1ca7f23cc4b72a"
    sha256 cellar: :any,                 ventura:        "26157b01ec117bc0850c4f6057402b1b0120f40a6217a8777af974726481a94a"
    sha256 cellar: :any,                 monterey:       "09e1f3dc85c0f8a064ad0e953e32724b816e32578677d6291893c361a8da7e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4881b5b7514acfbbcc15635b7ca20ca92d6b835d971a6662ecfe244d1e54df5c"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <stdlib.h>
      #include <libplctag.h>

      int main(int argc, char **argv) {
        int32_t tag = plc_tag_create("protocol=ab_eip&gateway=192.168.1.42&path=1,0&cpu=LGX&elem_size=4&elem_count=10&name=myDINTArray", 1);
        if (!tag) abort();
        plc_tag_destroy(tag);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lplctag", "-o", "test"
    system ".test"
  end
end