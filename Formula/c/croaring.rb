class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://ghproxy.com/https://github.com/RoaringBitmap/CRoaring/archive/v2.0.2.tar.gz"
  sha256 "92636a931f8a7bf36ce5a96d3039db128afd0e075f5aa7936fa1685dd2bbc75b"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "046bf6f4676e96f62943dbcedddacaeada91153d99c7347377f6e109c3ab689c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88862dc2dcb07f6d762556c4cde462f8cdea7dd276bed13023457c85b16d4492"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9915467788aed63be4a93c8cb43da0446da8cc73631c7de4d87c1d04edca16e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "378a0661295c127c8bd5af7ea877b3cb322b3816308c7e3b6d3f052d8dc8691b"
    sha256 cellar: :any_skip_relocation, ventura:        "c3d869a067da9350f480ea7b6952a9f0f0f146e0e75066ed5565159d830ab778"
    sha256 cellar: :any_skip_relocation, monterey:       "fb39c9214489ccac9b0377f274a0b41a7786a14704a6eb0e855cfcc646f603ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a25b522febc6409f96dec4e1fad3842bf5285675ba5305a71a0f970ad1f555fa"
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