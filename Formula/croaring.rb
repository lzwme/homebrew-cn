class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://ghproxy.com/https://github.com/RoaringBitmap/CRoaring/archive/v1.1.4.tar.gz"
  sha256 "9cdc5c4eaee857d1560ef0ef32b960cf3a36eb143a1cd72563afa337e389c5d5"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "247e334788abb2cc8d13fdf6720ef6dcc93961cd2d17182787d32025351308b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3ebf96e38b4c0149f4277cb1044ebaf3291634b27545228e0d1b66dcc2377d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c2433785712e3eeb13f54112863196c52f3917ce8cf9cfaf64fd8c64f28fe31"
    sha256 cellar: :any_skip_relocation, ventura:        "53eb3a59e7e3d1bdc7b23b000f63223164d53ac4016977d850c7fb91b1b1b36e"
    sha256 cellar: :any_skip_relocation, monterey:       "ef008a62d2102e8f66cad61ea4d13af9271c886ac10462231ca2c20166537ec4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3ff1958f42951b22dd48886e112836b8b817c266b321575407d6622c59defa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "847c5ea44590659bd7e1c1167bd56786760f2fdcb79248f8668c24f3f765ad62"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_ROARING_TESTS=OFF",
                    "-DROARING_BUILD_STATIC=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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