class Cmocka < Formula
  desc "Unit testing framework for C"
  homepage "https://cmocka.org/"
  url "https://cmocka.org/files/2.0/cmocka-2.0.0.tar.xz"
  sha256 "b5686c51ea92d142958d68e5dcb932f9bfc32cd3dd01c524f9d4aa863ebc3d9c"
  license "Apache-2.0"
  head "https://git.cryptomilk.org/projects/cmocka.git", branch: "master"

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e61b47c1bd763f33ed9c8d6c35013c1ec49c80fcc789e953110d3267f345c102"
    sha256 cellar: :any,                 arm64_sequoia: "8f9d3996bdb718f011fd7afcceaffa07ab93a3b277b55a2ac4776ca82c0b70a6"
    sha256 cellar: :any,                 arm64_sonoma:  "4c83cad13d8e21017bb8cfc5678729cba6d8bbfb11ddb6f25213abd3dd69a6eb"
    sha256 cellar: :any,                 sonoma:        "a9bc30a0be8d2f7b9f3f3bcd27658114c19ca566c6a781b8ff52a6e2d694e92e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c73fa42ad47ef6b63964472eacfcf9b09e3f566c8fc65c4cec09f82e89f5920c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d86f36667a10b7fae19abb70b3698cad4895a860453938639a9eab9833453c4"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DWITH_STATIC_LIB=ON
      -DWITH_CMOCKERY_SUPPORT=ON
      -DUNIT_TESTING=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdarg.h>
      #include <stddef.h>
      #include <setjmp.h>
      #include <cmocka.h>

      static void null_test_success(void **state) {
        (void) state; /* unused */
      }

      int main(void) {
        const struct CMUnitTest tests[] = {
            cmocka_unit_test(null_test_success),
        };
        return cmocka_run_group_tests(tests, NULL, NULL);
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcmocka", "-o", "test"
    system "./test"
  end
end