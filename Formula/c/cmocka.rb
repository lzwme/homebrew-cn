class Cmocka < Formula
  desc "Unit testing framework for C"
  homepage "https://cmocka.org/"
  url "https://cmocka.org/files/2.0/cmocka-2.0.1.tar.xz"
  sha256 "3f3533382ba29ab3abf5c4f4b27b79d165f0df51ea587de749b11b68b4019180"
  license "Apache-2.0"
  head "https://git.cryptomilk.org/projects/cmocka.git", branch: "master"

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "148cfc485e0a3e6dd354dc89c7981f33df53ea0674739530808052bfc25e8b9b"
    sha256 cellar: :any,                 arm64_sequoia: "4a1a1706a59c01277527c6335d9159b34ab62667a6be88b2d55161d817bdb02b"
    sha256 cellar: :any,                 arm64_sonoma:  "d187ef26bcf057f3d055b3dbd4f0f892d248e97108ce6ca2ae0272d90540a279"
    sha256 cellar: :any,                 sonoma:        "15023570231b7ede42054ff5e6dfea93bae217569f82bb6943a6a854b04c277a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "167eb5ab61a65e203175230dfd1aeb67a86812ad1bd54711bf2a388a5c1137b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daa4da82848edee801b09f099e5714edbb90f8863ef66a90246979ed82c39ab9"
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