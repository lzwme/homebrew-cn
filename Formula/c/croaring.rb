class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https:roaringbitmap.org"
  url "https:github.comRoaringBitmapCRoaringarchiverefstagsv4.1.5.tar.gz"
  sha256 "7eafa9fd0dace499e80859867a6ba5a010816cf6e914dd9350ad1d44c0fc83eb"
  license "Apache-2.0"
  head "https:github.comRoaringBitmapCRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11add481ed02ce5aec1b1f8b971b6bb305f56750c4fde2616f8ae2e21de51f79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c9fc6a854fd09bd38e09e0ba1686d8c7a753a977177aef3a247dda23ad72fb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb326f64024245f9924ae4c6f4ac87b5b7cf36a021cf69625446e421bab7b535"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d47fde9687b9dad114e2992de272869d704b66ccf2d1bc507c37f3dc29e9944"
    sha256 cellar: :any_skip_relocation, ventura:       "958ceacea1d74bec8c5a96097acd20c2728a3c07be42a411c9b2165dd1a69f3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f40223e4665ba3535b35b78452ded73e8867ae16d74e9361448e9b29dc55842"
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