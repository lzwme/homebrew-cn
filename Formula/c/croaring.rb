class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https:roaringbitmap.org"
  url "https:github.comRoaringBitmapCRoaringarchiverefstagsv4.1.6.tar.gz"
  sha256 "f6f2555da357332f709fd99afe5f136a8104a18c937fbd2c688f4c826c215489"
  license "Apache-2.0"
  head "https:github.comRoaringBitmapCRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37e2843d3f35a73ac5b522e96f78f8b8b84e3ec8b6bb94608b68792772e927ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8539a8c12bfe4505efb15ed285fbc3331cdb1017978234704a47f0b9dc69d52a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9558dc5882ed047a0c9d9c5c293e2b5d629dd888d6dc12c5924c9f352ab6f7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d352d98d738b69091d782ebea735c426839b5088f255b8dd8ac193c9e6e1abb"
    sha256 cellar: :any_skip_relocation, ventura:       "465d4f72f2e7ebc2c85345476ff7f972eefc9afcfac40412086d0d24b1c393ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6618c155036cc9c66de2bebb2b2e426a6d6387c93fac9eca25a6486e45517bb4"
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