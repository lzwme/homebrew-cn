class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https:roaringbitmap.org"
  url "https:github.comRoaringBitmapCRoaringarchiverefstagsv4.2.2.tar.gz"
  sha256 "3e66b1930db5c9ec292f58d8ee1099557c794ba359408d53f399a3e25a2a3bd3"
  license "Apache-2.0"
  head "https:github.comRoaringBitmapCRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a524f5c74e32202c7ba1b9c34d14c12b208cb0e8eb7e6bdd02ed16cb1e2d4567"
    sha256 cellar: :any,                 arm64_sonoma:  "01b6f1e8c6954868aef242c5e7b0f314d472cd4e79f6aca15f6ec133e07c53aa"
    sha256 cellar: :any,                 arm64_ventura: "9461c39820ecad69522bcd8e0a0b4149841c72104c16148d1c02266156fb0e8e"
    sha256 cellar: :any,                 sonoma:        "913c4c5015731dc2a940b62343e111aafe883a4814f52e7f035824edf483be4f"
    sha256 cellar: :any,                 ventura:       "2ad12c833bcf02032876518d4aaa8dd59b42eb12d5efdfc4e6ef900a12e4fd58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63092a015aa05a5f4e9b82f12348dc6f53d845d13b5509191a9c31f700be4ebf"
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
    (testpath"test.c").write <<~C
      #include <stdio.h>
      #include <roaringroaring.h>
      int main() {
          roaring_bitmap_t *r1 = roaring_bitmap_create();
          for (uint32_t i = 100; i < 1000; i++) roaring_bitmap_add(r1, i);
          printf("cardinality = %d\\n", (int) roaring_bitmap_get_cardinality(r1));
          roaring_bitmap_free(r1);
          return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lroaring", "-o", "test"
    assert_equal "cardinality = 900\n", shell_output(".test")
  end
end