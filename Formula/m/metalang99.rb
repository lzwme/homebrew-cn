class Metalang99 < Formula
  desc "C99 preprocessor-based metaprogramming language"
  homepage "https:github.comHirrolotmetalang99"
  url "https:github.comHirrolotmetalang99archiverefstagsv1.13.3.tar.gz"
  sha256 "91fe8d4edcc2e7f91c5b567a2b90f2e30c2373f1ebbabcf209ea0d74f63bc1e9"
  license "MIT"
  head "https:github.comHirrolotmetalang99.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "32b71a356b77df0dc6f4deee767caf0e383aec97be42eb4c7a5361a1cd595850"
  end

  def install
    prefix.install "include"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <stdio.h>
      #include <metalang99.h>

      #define factorial(n)          ML99_natMatch(n, v(factorial_))
      #define factorial_Z_IMPL(...) v(1)
      #define factorial_S_IMPL(n)   ML99_mul(ML99_inc(v(n)), factorial(v(n)))

      int main() {
        ML99_ASSERT_EQ(factorial(v(4)), v(24));
        printf("%d", ML99_EVAL(factorial(v(5))));
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-o", "test"
    assert_equal "120", shell_output(".test")
  end
end