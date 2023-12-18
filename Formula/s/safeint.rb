class Safeint < Formula
  desc "Class library for C++ that manages integer overflows"
  homepage "https:github.comdcleblancSafeInt"
  url "https:github.comdcleblancSafeIntarchiverefstags3.0.28a.tar.gz"
  version "3.0.28a"
  sha256 "9e652d065a3cef80623287d5dc61edcf6a95ddab38a9dfeb34f155261fc9cef7"
  license "MIT"
  head "https:github.comdcleblancSafeInt.git", branch: "master"

  # The `GithubLatest` strategy is used here because upstream changed their
  # version numbering so that 3.0.26 follows 3.24.
  livecheck do
    url :stable
    regex(v?(\d+(?:\.\d+)+[a-z]?)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5290276d5288c90d6cc8500ea2b05c236e94834fe06176aa258a1e68752b8b75"
  end

  def install
    include.install %w[
      SafeInt.hpp
      safe_math.h
      safe_math_impl.h
    ]
  end

  test do
    # Modified from:
    #   https:learn.microsoft.comen-uscppsafeintsafeint-class?view=msvc-170#example
    (testpath"test.cc").write <<~EOS
      #ifdef NDEBUG
      #undef NDEBUG
      #endif
      #include <assert.h>

      #include <SafeInt.hpp>

      int main() {
        int divisor = 3;
        int dividend = 6;
        int result;

        bool success = SafeDivide(dividend, divisor, result);  result = 2
        assert(result == 2);
        assert(success);

        success = SafeDivide(dividend, 0, result);  expect fail. result isn't modified.
        assert(result == 2);
        assert(!success);
      }
    EOS

    system ENV.cxx, "-std=c++17", "-I#{include}", "-o", "test", "test.cc"
    system ".test"
  end
end