class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://ghfast.top/https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v5.2.3.tar.gz"
  sha256 "dc50d870559af47cbbd60cf83d98ca141dddad4c19e5af262cd0bacc1d67df2b"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0a33740d63cf4ef1eb5b87e32e9683d129ce8d78bd0cd3759ea3faa95ded7657"
    sha256 cellar: :any, arm64_tahoe:       "5c09739c61f6b2a082f2b0714d62fca737fe8146872f7349c40e0e87ad3f7f92"
    sha256 cellar: :any, arm64_sequoia:     "1f7a1ed37c239d8dbf5f341264ed418d57853ec51cda51ac90026ba187f7e52f"
    sha256 cellar: :any, arm64_linux:       "967bbcaec7fa97884af4418c9ae1428637f48848cf1c1f16ef4e8621df46c765"
    sha256 cellar: :any, x86_64_linux:      "5662c2a43d24967c9d40aa2f49015f56fc55c425579bdbaf498f32cf94223496"
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