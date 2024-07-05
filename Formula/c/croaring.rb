class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https:roaringbitmap.org"
  url "https:github.comRoaringBitmapCRoaringarchiverefstagsv4.1.0.tar.gz"
  sha256 "0596c6e22bcccb56f38260142b435f1f72aef7721fa370fd9f2b88380245fc1d"
  license "Apache-2.0"
  head "https:github.comRoaringBitmapCRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c29bc3895233843f3f1b922d2100cd88d40ce12463521f3d2400106477c3131"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "701f03e1e3473e0949afb2a97e8fdc7fe2e657dd5ea01949b7b1979c1e0822f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f07fb4fb72da8497959e0457f9b9a2bc48b8ebb554e1239c594a394125ee51c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "dec51a6108c44466f81d22576a1e0763c4a3ebc2b11a698bd4b63e634a559b04"
    sha256 cellar: :any_skip_relocation, ventura:        "439559adeb43418d7467182d6db9c47954e93fa4ac17baa1359e5f88fea626d7"
    sha256 cellar: :any_skip_relocation, monterey:       "f3a41f0a100551bc8d333ac009adf142d50d7ff4e64dcf3b59256029f57ef2c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d12ae1220a35115189295dc3179a1b5127d7aea06f1c160d38b135d325fb8e47"
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