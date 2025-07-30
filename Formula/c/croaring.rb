class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://ghfast.top/https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.3.6.tar.gz"
  sha256 "d9c63e6fa06630cd626be004a226bea15eb4acba6740a46f58c6b189fa5d49b3"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e7c11d96c0df0ac8cccc022826d31c741d8caa9540269d43c55f9772327b44ef"
    sha256 cellar: :any,                 arm64_sonoma:  "57af35c209e64d836559e6d0b5d67e6d3a9229abc8b3096aa9a0d8ba853b5ccd"
    sha256 cellar: :any,                 arm64_ventura: "277686418c67364a598208860528d9dbd673554d88cb7f3ce50c5287b38f7143"
    sha256 cellar: :any,                 sonoma:        "bd7bb069d1e71393ea3cbbc52564615ac91d4d513d9a729d629f5a7b2773cd69"
    sha256 cellar: :any,                 ventura:       "61fbabe8f7393f3f2d931e2b94e18703bab521a7015045c3a1214ca9efb490a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "407aecccb57f4815329635530e9a07cf570dcb3beb5526eaa481d5fdc058f292"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0596d8e52dd3df24fb70b6822d21331c49a81af088e098650d8f24ca0d7bf813"
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