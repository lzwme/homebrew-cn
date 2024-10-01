class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https:roaringbitmap.org"
  url "https:github.comRoaringBitmapCRoaringarchiverefstagsv4.2.0.tar.gz"
  sha256 "b5f2d184b0872f57dce911cb520925539cfa851deda516d1239e8e06aff96439"
  license "Apache-2.0"
  head "https:github.comRoaringBitmapCRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "87f8bbcf689ef1a542ed8cb44f152789d071bcf2236d6a140bf5ed350c11deaa"
    sha256 cellar: :any,                 arm64_sonoma:  "72911b822dfea8ea1cb55230f59ff3f373e2b778f3c6edbd92ca425e5d3ed039"
    sha256 cellar: :any,                 arm64_ventura: "b7b9fcc573dec988be1ade724fbe96021c175d0a79e8e9ba5f0a68cf4806f848"
    sha256 cellar: :any,                 sonoma:        "6ce60b6ddf01d5065689ebccfa26e6a90695bf601bdf5b8fad427ce46365f1ba"
    sha256 cellar: :any,                 ventura:       "e1e78d222aad887e440540e9e36575c307286959ecc9b5712173d1dd0665681b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "870e31742257ff334bbe20c84ab1109c0ef59ac2d96fc7393ee00805b0a9afb6"
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
    (testpath"test.c").write <<~EOS
      #include <stdio.h>
      #include <roaringroaring.h>
      int main() {
          roaring_bitmap_t *r1 = roaring_bitmap_create();
          for (uint32_t i = 100; i < 1000; i++) roaring_bitmap_add(r1, i);
          printf("cardinality = %d\\n", (int) roaring_bitmap_get_cardinality(r1));
          roaring_bitmap_free(r1);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lroaring", "-o", "test"
    assert_equal "cardinality = 900\n", shell_output(".test")
  end
end