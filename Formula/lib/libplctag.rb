class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://ghfast.top/https://github.com/libplctag/libplctag/archive/refs/tags/v2.6.8.tar.gz"
  sha256 "ffc48bcf6a0023d7298cfeef7f607749aa0da172a8c840810760724b5dbc7577"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1dceacfd75bd6913930b562961eb67e9c52ffe7a46f2a22b3c80bb45d9fc8244"
    sha256 cellar: :any,                 arm64_sonoma:  "57f807596282ac81d10909679d8b5b02aa308f1915346f89644e36dbc52e1763"
    sha256 cellar: :any,                 arm64_ventura: "86b8c204f3bc56db6c7283d9b1e97ed3302b73eb880cd471200817f313a3c000"
    sha256 cellar: :any,                 sonoma:        "d32095d0bc3f91b62b0e845524ea4a54763005aef57a5cbb1993d67d4850a8e9"
    sha256 cellar: :any,                 ventura:       "79c46ff24074e4484593f416b9322c8489696d4c634dda30f2f27e6f15ba3916"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec3dd8616892279769070c12c4ea6f8b6243f3b9364bbc44768cba0f8a3bf02a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe566242903c1c142a3e846524e8e868e71e255da8e308b72f15d86f624eed6d"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <libplctag.h>

      int main(int argc, char **argv) {
        int32_t tag = plc_tag_create("protocol=ab_eip&gateway=192.168.1.42&path=1,0&cpu=LGX&elem_size=4&elem_count=10&name=myDINTArray", 1);
        if (!tag) abort();
        plc_tag_destroy(tag);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-lplctag", "-o", "test"
    system "./test"
  end
end