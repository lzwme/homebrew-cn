class Orcania < Formula
  desc "Potluck with different functions for different purposes in C"
  homepage "https://babelouest.github.io/orcania/"
  url "https://ghproxy.com/https://github.com/babelouest/orcania/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "e26947f7622acf3660b71fb8018ee791c97376530ab6c4a00e4aa2775e052626"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8b7f8c6ad6bef28777ffa342338aae906c0c8d62c060fd66b89f7b5219e39a0e"
    sha256 cellar: :any,                 arm64_monterey: "60cca6feb94ed04aed4ee902980e7f98115efe4f44c03d3279c217776dfe23d3"
    sha256 cellar: :any,                 arm64_big_sur:  "1f29dc9ca40b0b9411705a5b55db2739be4d8e72db4f311d48892a192ec91232"
    sha256 cellar: :any,                 ventura:        "04e91894340f16e77b29b974885922c8812a8c4d94fc3098ff21ca948747d1df"
    sha256 cellar: :any,                 monterey:       "49b66d5ad6ad86a71a736c8e171843d4d6d0e83a23d94f4acd78cd90269e761a"
    sha256 cellar: :any,                 big_sur:        "18f44c9ca72121336f4333774fcc6cd09c8abcebd36a2e0a4877dfcc91a7cd86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd436eb031d76eb857b159813bee79f30712400f420072ef8b57476b3ff26851"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    args = %W[
      -DDINSTALL_HEADER=ON
      -DBUILD_ORCANIA_DOCUMENTATION=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <orcania.h>
      #include <stdio.h>
      #include <stdlib.h>
      #include <string.h>

      int main() {
          char *src = "Orcania test string";
          char *dup_str;

          // Test o_strdup
          dup_str = o_strdup(src);
          if (dup_str == NULL) {
              printf("o_strdup failed");
              return 1;
          }

          if (strcmp(src, dup_str) != 0) {
              printf("o_strdup did not produce an identical copy");
              free(dup_str);
              return 1;
          }

          free(dup_str);
          printf("Test passed successfully");
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lorcania", "-o", "test"
    system "./test"
  end
end