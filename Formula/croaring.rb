class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://ghproxy.com/https://github.com/RoaringBitmap/CRoaring/archive/v1.2.0.tar.gz"
  sha256 "b389e9cb5dbe74f65023573be03388f944c733dc89534674c55b0a175438603d"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b863499a8f3c3ada3c35ebee09761a2b05758da07bb4395222a327647416f3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af79fed3154adf2b56ef5cdffbe6063b3c0971245e86ce7fc14667a5bf7cfea2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aca55e7120856450faa1e3f97c1c137f051245f8bd7b543d10a52e453012c62f"
    sha256 cellar: :any_skip_relocation, ventura:        "5cfb7f566be2872ddd623fb1e10cd1fabf5b76f9661c38e054c2efd13fe30fb8"
    sha256 cellar: :any_skip_relocation, monterey:       "14024838b7278f871e8843f45d7fc4f3dc6d3e320e69210c43c1c1df0aacdc43"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e7675075570f406e6e44dd3a02da28586f5343614435831c484f225f5d8b670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa0f8ac3df92c443dd7ae57c1ea1380c67645f66f7a8150442034b4ef444e782"
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