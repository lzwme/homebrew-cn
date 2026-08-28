class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://ghfast.top/https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v5.1.1.tar.gz"
  sha256 "baedea962cd8570487de4739fb09d265ae11afdb415a53caa867b2eabf86ec29"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dd25c20a4ac6df899e4788e3ef694eb58ef3a7df2713984efe31fdee71823229"
    sha256 cellar: :any, arm64_sequoia: "8fe21616b3e65ba88aba22e9225da3fb833a2ba1a31b8e20dafff4a9d53c905e"
    sha256 cellar: :any, arm64_sonoma:  "8f6cfe393211dfb00ef6e3b9dab2f0a25d69c5ffa93051c2b5bb1b0975cdb0df"
    sha256 cellar: :any, arm64_linux:   "e175b48755b25e1a45a3558ef24fd492fcf5a0b6bf3d5255379a6911f7c40a1c"
    sha256 cellar: :any, x86_64_linux:  "f6f9ba879ba84b5ff1baa515bbd5a7c3d259a30e4c47b32374c94f7a5ac02f10"
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