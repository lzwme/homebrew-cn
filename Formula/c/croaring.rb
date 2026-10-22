class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://ghfast.top/https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v5.3.2.tar.gz"
  sha256 "f8eba67b2655cd6df08f4f92cf104cde5e4f7fa5280bccad0ec6b79c6734cd08"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d469086e4e508f4fb7bae41a8276fdc43278cd6a7b16b651c1b674605ac35e4e"
    sha256 cellar: :any, arm64_tahoe:       "f7d88cb875eb803391893dac88e66bddcc96cf2f88c1e6c3f39fc5a56ffe8d9a"
    sha256 cellar: :any, arm64_sequoia:     "c2e282997c398e1be5d28795eb64a22cbc881cff7d29bde4f0622ed55c96391c"
    sha256 cellar: :any, arm64_linux:       "57375c4236f76ba4130b5ce39185c43b709af70e1e3b5233f4c52da2cc3cf02c"
    sha256 cellar: :any, x86_64_linux:      "e53a30ac51793cf6de1b8a9e121302a985d55365c83eddf05c5fadbf5a594a09"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DENABLE_ROARING_TESTS=OFF",
                    "-DROARING_BUILD_LTO=ON",
                    "-DROARING_BUILD_STATIC=OFF",
                    "-DROARING_USE_CPM=OFF",
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