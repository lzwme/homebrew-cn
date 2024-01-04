class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https:roaringbitmap.org"
  url "https:github.comRoaringBitmapCRoaringarchiverefstagsv2.1.1.tar.gz"
  sha256 "40a1c04e220bb2305c3adb5347f42b6b435c4bb4ac89dd0047ba8e73a7388dfb"
  license "Apache-2.0"
  head "https:github.comRoaringBitmapCRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94ad93f2d273d6a1ebd17856539582d53ad84d523c9867bffabc6c7d83351392"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1b64b522eb358e1646c1dfb653f53b8abd6e34089b352008c9bf53ab58c6b9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98e8039b6d7d5e2b80eb150ec0cc9f73bab9a80d15236b8cfc9c4017e1d49e18"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a3551f14433fc5331f7d14b0d797b1f988f8337283914ed5a43a1882435b726"
    sha256 cellar: :any_skip_relocation, ventura:        "b8edaaf8810af697bc290a4b63e23ebe814437d82d920b9a9a621bcb9b3ae7af"
    sha256 cellar: :any_skip_relocation, monterey:       "110866d9f63a099c6db40dc94a0f8a66e7c036cafedf6c9f579f7ba56d0bfe44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3e1afb8374d366a9d9e3880a62557aa0198ba992dea533f4a022056a471f109"
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