class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://ghfast.top/https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.3.9.tar.gz"
  sha256 "7e3150f21a5e064d302610828b575524b51c5626520b7533b4fd6aea623175c9"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "40524e98d254b4c8371ab13e47f43d51b05927e88d5461c5d2b23f9da9895b67"
    sha256 cellar: :any,                 arm64_sonoma:  "dcd2359f1453d5e7d810e596695c623f5dc8becc5f9df6a19027a3a883e70a79"
    sha256 cellar: :any,                 arm64_ventura: "00042eb729d3b5e9c2c4207336dd99d421b8a70e8cd004559bb33f05f28e2593"
    sha256 cellar: :any,                 sonoma:        "e8e4c059b759dd17c9f9a58e8c27246f20a7183af41f53886c001cf047069fc6"
    sha256 cellar: :any,                 ventura:       "d521202bf49485fcafe155864a11b8d9dfa75de903e464722f43d869da375d9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6887b4786ba1b074ca657b462750a82bf1d920be3e2bfd56818feb0564def835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "486eff2a1648ef84d512c4d20763a129add8117000ed3bd371b74c18b2ac5afc"
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