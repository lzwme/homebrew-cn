class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://ghfast.top/https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "5f6ce15f23cb70fca04839d186a15ceb540e31d650496e0a2c8284a882465b13"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5b1e6abbb11b168acf393245e205478eb11e1a69ae139b088a70a312a19e1422"
    sha256 cellar: :any, arm64_sequoia: "7bfcd8105df33579bfb5dfa8444f11999b05ec0a75ea53cf45f3ca4d98163719"
    sha256 cellar: :any, arm64_sonoma:  "3d87e01e5c8a8867f12ebc0cc75690b8d0659cab8f97ba202faea4c4c53ae56e"
    sha256 cellar: :any, arm64_linux:   "74538ec623252465024192b046f954c3a5ccf5c5f41f12acb4d8d94b80d62bf7"
    sha256 cellar: :any, x86_64_linux:  "2bd5e1d512cf9889b0bdc6971f9723624d9130d3e0fc43fad6684a62b8ffd72f"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_ROARING_TESTS=OFF",
                    "-DROARING_BUILD_STATIC=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DROARING_BUILD_LTO=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <roaring/roaring.h>
      int main() {
          roaring_bitmap_t *r1 = roaring_bitmap_create();
          for (uint32_t i = 100; i < 1000; i++) roaring_bitmap_add(r1, i);
          printf("cardinality = %d\\n", (int) roaring_bitmap_get_cardinality(r1));
          roaring_bitmap_free(r1);
          return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lroaring", "-o", "test"
    assert_equal "cardinality = 900\n", shell_output("./test")
  end
end