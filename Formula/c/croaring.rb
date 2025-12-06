class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://ghfast.top/https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "8f945ad82ce1be195c899c57e0734a5c0ea2685c3127bf9033d4391d054f94ab"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c4a26918724ad74ead8cf00c5a90ca4b6577cbe2036354eec40414094778f3da"
    sha256 cellar: :any,                 arm64_sequoia: "4ca83e6549e3e158b752b64ca3a50a0877e5fe75fba1986b36e0fc0a131d3ef7"
    sha256 cellar: :any,                 arm64_sonoma:  "febf5c4cfd0a17573e0fc504d1bb4734e23161a022864bd2be5a2635be8451a1"
    sha256 cellar: :any,                 sonoma:        "3badc9ceee23c101a43b808ed14ba957b7d48b97910aece91a81a4ceb81bde6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25ca85c30e28142719975e4432c532d1dea8d6f9a830bd3fdebf556cd65e0b43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3adf411d7873d02051d29a077738b476c0a5ac15e776340c6a39ebaf455c32f"
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