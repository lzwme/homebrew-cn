class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://ghfast.top/https://github.com/libplctag/libplctag/archive/refs/tags/v2.6.9.tar.gz"
  sha256 "56788001cb699fe566415b23bd35e0bba98c6153466f0ee87ed0cf0a8606c3c1"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "236b1fdb6a84b9455e0e91527d4f7a936d07d4e0f609ba34cac0c9757ce8a145"
    sha256 cellar: :any,                 arm64_sonoma:  "8d9f996578b3478c6efe3710ab234cf5b2710e4d3a4d1194aedc7bd0ba39cad9"
    sha256 cellar: :any,                 arm64_ventura: "77e4d4d48fe223a7900ae049b8913b93c67da6ad2f64cbd95e935bd5dccd8c3b"
    sha256 cellar: :any,                 sonoma:        "49da19608f2befe95d5d8430fb57318065d4e8813337f1f69b01b4119270760f"
    sha256 cellar: :any,                 ventura:       "2317542d9d13f3dfa3bea8bf9b76c52ef5b8246360369190ccd8459b3cd01f2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40f7c7a281d8e2fc33389900ea195101be6640ee54d99c9bfaea3358fb8fac6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acb62be985916ecf3f267da898d70733f7936cd8afb4f65eb6d10b42aacad64f"
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