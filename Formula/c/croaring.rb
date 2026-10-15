class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://ghfast.top/https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v5.2.4.tar.gz"
  sha256 "0047582c0b1ac7a2a950156f0b23b52ad060dbfbd1f082939ffa369014675838"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8c9f28974ee315d1eae65f157426a0ffd12d92909283fbc186f9dfa2e737d1cf"
    sha256 cellar: :any, arm64_tahoe:       "f87675c1a5e8980eb6646f86d46f9c5838682bd563a21e304e8a3752742ff0a0"
    sha256 cellar: :any, arm64_sequoia:     "291f27666b0c8812266f15945665e1647e648b0d97341cc602fd1fa4fa72256c"
    sha256 cellar: :any, arm64_linux:       "200d5c66b24d78e75ea40d6db3e717cbcfacfbf75009f0c651d0fb7cdb5b3fea"
    sha256 cellar: :any, x86_64_linux:      "bf08fc77fc695d37c232e1c8430a0ec1414611ca2f4ee1f953f5f31d11ffe3d3"
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
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <roaring/roaring.h>
      int main() {
          roaring_bitmap_t *r1 = roaring_bitmap_create();
          for (uint32_t i = 100; i < 1000; i++) roaring_bitmap_add(r1, i);
          printf("cardinality = %d\\n", (int) roaring_bitmap_get_cardinality(r1));
          roaring_bitmap_free(r1);
          return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lroaring", "-o", "test"
    assert_equal "cardinality = 900\n", shell_output("./test")
  end
end