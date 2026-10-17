class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://ghfast.top/https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "52509f2374d33543a14abcaed77946fdca731ca697bfce580f0b6d2a88119bdf"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d108794da67c1dc4dae9823829999d660f594e6c075b3b10f45e7afd71538f7e"
    sha256 cellar: :any, arm64_tahoe:       "a5a4549f2c4c62ba8d217b940b57d351179fae279f2bd615db0ad7c6e2e38024"
    sha256 cellar: :any, arm64_sequoia:     "69ddc678ab60f3224fcfd03c0e624449ae289b6923de5f06fd9277aa02834afc"
    sha256 cellar: :any, arm64_linux:       "648fa8b6533c7f188d840a2368e0109527267702503101ad753a5879515bbed8"
    sha256 cellar: :any, x86_64_linux:      "58c589053b6369e4958abe8673d18d367d936e9c771f6da3e44a7d8c6a91d05c"
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