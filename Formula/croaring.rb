class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://ghproxy.com/https://github.com/RoaringBitmap/CRoaring/archive/v1.1.3.tar.gz"
  sha256 "3020cf4f36c40c736166c636aaf1b7ea619a9c5fe943d3f85ca2f81a4ef4ab84"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81ab6d8897434e1d19d511827409e5824e2475bcaa15c02b0420459fb3b7e31f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d668556989c22e9bfa4527bb04bbd6ce63472bc7e0bdefacee78b234267cac2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0cdbde9ab6a3c0e6114306eae4bfa38ee5b89e44d5bf0fac928b2fdfc9c4bbe"
    sha256 cellar: :any_skip_relocation, ventura:        "f24fa1a487197edb34841bd5ef173c997b1285b6010e4a78e3395466c37f680f"
    sha256 cellar: :any_skip_relocation, monterey:       "520aa0785b2ae308255670908e96c1d0af12430eaf3ba68314d44b2538d1ff45"
    sha256 cellar: :any_skip_relocation, big_sur:        "2185f7a3cd67e0c3e8ae0771d1d9c20db4e9ea8f34eee318e1d49443a15cbf15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eeddd5c9bca9b7f95b82a497513d0d76f5821d550a9af4fbc0f238bc6ec5ef40"
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