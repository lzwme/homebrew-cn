class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://ghfast.top/https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v5.2.1.tar.gz"
  sha256 "c412b3cc63292ff8985f5976819b2bcc3375806cc47a41bc25b70ab4a376b00b"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e7a8c9ea897a3ffe754152742efc0a979463d1ddc10a1e69f355329a954952cc"
    sha256 cellar: :any, arm64_tahoe:       "4de2410ac2a74a22921d014c7aa84e10fd77ea99bc83aec033c9436919db486f"
    sha256 cellar: :any, arm64_sequoia:     "c7f363a90098a83387ba4c551d2f3ffc5f2104c8c71d9279b217e629eddeb007"
    sha256 cellar: :any, arm64_linux:       "ddacf2fe471ef2a5d2e88f2ac14a7494c42621d5a557a58573d88a4e9e01cd1c"
    sha256 cellar: :any, x86_64_linux:      "51273db7babb411c1fe00a82e4d87b0e5d51b325e9c31b5ea55ced98ed9e7612"
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