class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https:roaringbitmap.org"
  url "https:github.comRoaringBitmapCRoaringarchiverefstagsv4.1.2.tar.gz"
  sha256 "dd9e9d9a28dcf9ba1622fb4a3a7b4d7f5e12732bb35e99a7cb028b7512731a7b"
  license "Apache-2.0"
  head "https:github.comRoaringBitmapCRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bb68d0dac58316a8846a667b5fc28c1a2d20d6b565e552af05b9aa31d6a0e44b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e03204f9bbcbc3ea35e447bafb44073e81c7bf597293c37ec57a9fce206ce5ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0b883f09a3878bd712bbc20f3a320a3ab2ebfeccefae1e702e14a17b4fcd896"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e541494b7974303efafb07a759f4aaf23ad1b3c43f0a034770839c6eb436c96"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad47dfb446026b8f4f22edfd9cad4eb55a19c2c5f5d18a0693ba52835b2fcc19"
    sha256 cellar: :any_skip_relocation, ventura:        "23bbb82346502f1ef791482fb4c7cfa33cbd5a4aa6632e613e99238917456354"
    sha256 cellar: :any_skip_relocation, monterey:       "41c96e1dcc2845a6a8e7f50261bb5ab73852f43ef0ef0fbc23b87a40b09ff52e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd0ccdee71de0631489197ff430ae4518147fc38957011943317bdabe672de08"
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