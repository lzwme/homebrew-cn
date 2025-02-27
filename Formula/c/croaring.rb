class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https:roaringbitmap.org"
  url "https:github.comRoaringBitmapCRoaringarchiverefstagsv4.2.3.tar.gz"
  sha256 "9f28c04bc5b818757e4bd857e7b78507b6fc9145d8f8da9bb2191c7c04fc3b9b"
  license "Apache-2.0"
  head "https:github.comRoaringBitmapCRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a77d36c1c11baef9624f2fb3c8c78a069d9787380a50c14e62ee1bf6f8e52b36"
    sha256 cellar: :any,                 arm64_sonoma:  "14fdab96a5f7eed28b6eeaa8a6d2ddf103808dac850754cccddb4d1c36452686"
    sha256 cellar: :any,                 arm64_ventura: "ffc2400109130139b6d1e7ce9a3f99ca6633e1fa53d79e4a06fdbcb573c2a3cf"
    sha256 cellar: :any,                 sonoma:        "0c6750ab26fb3c6fd089c2389ba0a443fdc9e8bf10197b3e1896f3c16dc28ed6"
    sha256 cellar: :any,                 ventura:       "d5e50f7de7f0dde7a2fcdcbf2b0e6b7fa14531319cf578bd041623ff13fde565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bc5ca8011247c040782ef96b3289a5b4fd0b7af0195a99c917985413933119e"
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