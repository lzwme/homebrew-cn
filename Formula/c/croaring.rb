class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https:roaringbitmap.org"
  url "https:github.comRoaringBitmapCRoaringarchiverefstagsv4.3.4.tar.gz"
  sha256 "040e475f754ce75f751e2d4722faa9e4d69d357dd3b666fbfd1fe8e16f1594a8"
  license "Apache-2.0"
  head "https:github.comRoaringBitmapCRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b4786a86f08b984d46605559f47366c282fcb0f0c1b56e61eca505b5fc207769"
    sha256 cellar: :any,                 arm64_sonoma:  "507d707987041d9a2c70ff3254cd35eb841cee62d0f25d1d319252dacea9095b"
    sha256 cellar: :any,                 arm64_ventura: "a2c7016c6f3cb881740a70e8af9f96e23972b2e2f8f62fae11b0933fac3a1b28"
    sha256 cellar: :any,                 sonoma:        "daf0b5869aa38cd4097c6c6b79e10ad7f3a6e9ea72cf96f5981ca44ae7142f39"
    sha256 cellar: :any,                 ventura:       "169c7fe5b66673a5e49f40884e49703ac2d047c26ec87631594b1c7e56a4e5bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35d1771203d07fa28940e2db3b6e22d1e24306ae5cd45a3acf9fd28aba203494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27e3b58f42d28be01c47232822f36043909811038bff1810793cc52f07cd55f6"
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