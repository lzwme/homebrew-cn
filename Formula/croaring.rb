class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://ghproxy.com/https://github.com/RoaringBitmap/CRoaring/archive/v1.0.1.tar.gz"
  sha256 "33cefdc38eebac40c43f6f68c21b24b9d34190eb3ca0636df9acb272e8595eb0"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f45936e1f63e790bac9ea614fc567c5e99e0c8eaac2909694165138f2133ab92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "502cbc9b674804696b5ebad3f2a24814ffe9b9a66e60fede7fc3be4355620524"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce4855d173b031acdd5b4c5587e57e71ba92a8ae7a2cae840df658799b68cbd7"
    sha256 cellar: :any_skip_relocation, ventura:        "d8653ef41c98d32abb3305d74ba22b4918c21603d4ce298c5a8b13558bfa697b"
    sha256 cellar: :any_skip_relocation, monterey:       "a2a1a7d37b30e806e32c6e3b6d7f9d79a44ca083ed6052c9930de73861fc13b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6c055d5e3ecc4472a6da91acdab127d147612f2df630a0387c0ca8876dfd08d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "addced81f55965bcaee8b79911004262facb23c79b535b9a2e3bacfbcc535d4d"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args, "-DENABLE_ROARING_TESTS=OFF"
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", *std_cmake_args, "-DROARING_BUILD_STATIC=ON"
    system "make"
    lib.install "src/libroaring.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <roaring/roaring.h>
      int main() {
          roaring_bitmap_t *r1 = roaring_bitmap_create();
          for (uint32_t i = 100; i < 1000; i++) roaring_bitmap_add(r1, i);
          printf("cardinality = %d\\n", (int) roaring_bitmap_get_cardinality(r1));
          roaring_bitmap_free(r1);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lroaring", "-o", "test"
    assert_equal "cardinality = 900\n", shell_output("./test")
  end
end