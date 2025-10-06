class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://ghfast.top/https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.4.1.tar.gz"
  sha256 "640d8e2107a4143000b39bd011d026e81d80e8409abe65ed0684837776f60969"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c68545b1e2500dac01cd2779c970e8b8f9a2243b44f12234b2036553c5f27035"
    sha256 cellar: :any,                 arm64_sequoia: "e049bf4a718f9ec125635ec765bb04115a85dfd3b0acf8f11efc61d87d0f8069"
    sha256 cellar: :any,                 arm64_sonoma:  "011856b292b0a7cd301f3b931cab058020e4fb7440670707f6ce53a40dd6328b"
    sha256 cellar: :any,                 sonoma:        "9cc79eb2f04da6e884e017ab4b583ffd687a2a25b97e6560411612c97545cf73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "985bd886e3a7da4461f731c8ee5e7b226169fd1baa3a1fb62f4e7401d74a5e6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ffe65fa6d1a0308224e8416bfb80d2a8877f80776d1cac3f077843fe420b326"
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