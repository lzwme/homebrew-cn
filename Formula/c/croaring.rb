class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https:roaringbitmap.org"
  url "https:github.comRoaringBitmapCRoaringarchiverefstagsv4.1.7.tar.gz"
  sha256 "ea235796c074c3a8a8c3e5c84bb5f09619723b8e4913cf99cc349f626c193569"
  license "Apache-2.0"
  head "https:github.comRoaringBitmapCRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ef549b264bd279860bcbadc87864cec5190e57c3882888b95267451e175ea4fd"
    sha256 cellar: :any,                 arm64_sonoma:  "2857bbee90abe21ce2d93b5c488e1cd6fa9255616afc9911fc557dc4e5b60813"
    sha256 cellar: :any,                 arm64_ventura: "385c81cdf434511632b69202b26f345e45e754f962003fb6a4104be547437419"
    sha256 cellar: :any,                 sonoma:        "f62195ead3f17955a7556234a242c05ffbfc3fb4095664ffb266ab6ff2565124"
    sha256 cellar: :any,                 ventura:       "087c06168a0a8b59f9c35f8621d36438d08f2281bb4040eb0ec5bcc006b883cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c21c57c37ae9a2bbd7e4097743da1d3ee0e4b468b667a71c7287254d739ccd6"
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
    (testpath"test.c").write <<~EOS
      #include <stdio.h>
      #include <roaringroaring.h>
      int main() {
          roaring_bitmap_t *r1 = roaring_bitmap_create();
          for (uint32_t i = 100; i < 1000; i++) roaring_bitmap_add(r1, i);
          printf("cardinality = %d\\n", (int) roaring_bitmap_get_cardinality(r1));
          roaring_bitmap_free(r1);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lroaring", "-o", "test"
    assert_equal "cardinality = 900\n", shell_output(".test")
  end
end