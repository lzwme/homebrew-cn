class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://ghproxy.com/https://github.com/RoaringBitmap/CRoaring/archive/v2.0.0.tar.gz"
  sha256 "c93c9e3f484b20e9c5f5c4d8f63f5e7b85953af21a3528e61104dc6186a1eda0"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ea8e964f79d0c59a8ed6a4714ebb5936062afcaffd0ca3f7e5eaa82d16fa89d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa16e4c1e3716ac6d0efa0bb1e202d4636a71f5f6618985ff446a74eaaef00b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46324b3c224089185c0a1c633351e4a8f7264fe86f535dab5b3d39934984278f"
    sha256 cellar: :any_skip_relocation, sonoma:         "897887eba3dd081ecea3bd02d01757c7b6eecbf2ac564d354b7b182959180f57"
    sha256 cellar: :any_skip_relocation, ventura:        "e95874909655f28b7bfa632ec35307d0492bf2bf879bbccf6d49951e1bcbd344"
    sha256 cellar: :any_skip_relocation, monterey:       "99906343a3d3253fa667056e607a5790a2c9c53bd044b867ba5c59e2c1b08d52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06606c473076c2318310113d0656db4ae4f182a9ffa1711f1333e9476d4287b9"
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