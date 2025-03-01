class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https:roaringbitmap.org"
  url "https:github.comRoaringBitmapCRoaringarchiverefstagsv4.3.0.tar.gz"
  sha256 "cd31d1f9637b1fd92345957c35000c9c0adc7065679c26fe6616df506f4cbc56"
  license "Apache-2.0"
  head "https:github.comRoaringBitmapCRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2bf39d304d6460d3e4a18c29864bc77804df23b5f8adeaacf0bee19dc8c8a46e"
    sha256 cellar: :any,                 arm64_sonoma:  "9463071c3335531bb98b376fa0fdd3840fa8eadc6d654e800890cdc4b4df23f4"
    sha256 cellar: :any,                 arm64_ventura: "569ea7794ba38fa6c889732ae684386d3f7887b68dddf9105b0785961190b280"
    sha256 cellar: :any,                 sonoma:        "49ec19d127c0d6931ab3f4ce60264e8ab58207f9ae57ebbfd5b446a4fcdf79c0"
    sha256 cellar: :any,                 ventura:       "a3724fbf3cb4a1130b57bf865bc26f6b6a0c1998c1798d6d6beede244c13fbd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db12a1c6f66d89e88ee9c1c2331e1378d6daec332e7ec622058a7d50c904247e"
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