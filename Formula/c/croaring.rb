class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://ghfast.top/https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "01d505ef29993267b892779f3a08e66ae78122abb61d196933615321542e9478"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "890c1a2380e6f2dfb65a1d7612c2eb0b893e9f6d6e138890b4753b4f56d29871"
    sha256 cellar: :any,                 arm64_sequoia: "a29a91f72d9d68ffe161ab780aaf9db286db37741b00bd0954bf995cc9b1d166"
    sha256 cellar: :any,                 arm64_sonoma:  "325389b27bed81b0e780bac7b5cc28ed8c9f67c2fa970059c1c782ff131704a3"
    sha256 cellar: :any,                 sonoma:        "ae55fe413b7fcfc4b7f876907389b0a0e67216d51bafcbfe51aa6d4d0a566518"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d518dd41c0f8483534ae3fa77dd1ff1123927f067c087cb43d4111cb7b10584a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63c104c1ef48f1cdc3abcde86c058f71d3670b4d1b29a22872036877c4caf871"
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