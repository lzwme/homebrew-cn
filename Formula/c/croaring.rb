class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://ghfast.top/https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.3.7.tar.gz"
  sha256 "57d96c566678087ba0ac248b9537c6df0d8600d1df9e38503121b42f22a382bd"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c8b55f64441a62a97eb43a80f5d8068763d42018778930d8fcca3a77f243e1eb"
    sha256 cellar: :any,                 arm64_sonoma:  "582df1279a3a4742b874e42396478cecea8bb552ec20e5308470a6e2397ba758"
    sha256 cellar: :any,                 arm64_ventura: "54c0050805e6d0c6c37361ae15a8164809213e4108e76b7815603c1590d509cf"
    sha256 cellar: :any,                 sonoma:        "37692752976a10e6bd1917ef56a5289dd207035aed76c9c2977a10a06c24f13c"
    sha256 cellar: :any,                 ventura:       "16920bf4b8f973017eb986992374a67dc9dc666f661152e4fa1bab725122cd60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "522ff53f07ad7c7bb0449de2c2791a526b298c0c0ec47822a50ee2d086708c84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d6fb7d0d808a7cb3bc74cf4127f172a2c813a70e8789e908616a7cea8ea83f3"
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