class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://ghfast.top/https://github.com/google/re2/archive/refs/tags/2025-08-05.tar.gz"
  version "20250805"
  sha256 "b5708d8388110624c85f300e7e9b39c4ed5469891eb1127dd7f9d61272d04907"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/google/re2.git", branch: "main"

  # The `strategy` block below is used to massage upstream tags into the
  # YYYYMMDD format used in the `version`. This is necessary for livecheck
  # to be able to do proper `Version` comparison.
  livecheck do
    url :stable
    regex(/^(\d{2,4}-\d{2}-\d{2})$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.gsub(/\D/, "") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e8cea942d88d1e6f50c7a0f7e5053a59d9314a769d6a015434f4596c687246c0"
    sha256 cellar: :any,                 arm64_sonoma:  "e3450b22338c751dd852f35dc5304c3a074721e13829095290c1bf6d1ab4ce13"
    sha256 cellar: :any,                 arm64_ventura: "968cfdca0fd6e19758faa32f3787adf80f60d5ce79f23561474e2eab9c8c0a99"
    sha256 cellar: :any,                 sonoma:        "9f4db8c62ccbfdfcc4c3849a659250106f416c9bc95695f502dadf01e8a58052"
    sha256 cellar: :any,                 ventura:       "13101f7c7802c012c43d024e0640cbe4b1bb93a5fe54394c33550a320eef7345"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33986a8eb7209dc22cbac9280950076ef0eba3336dc2fc7af4b0634e04a9227c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f3e135a502bcae632be673704aabcc48599bd0720addd276e893b987dfa7797"
  end

  depends_on "cmake" => :build
  depends_on "abseil"

  def install
    # Build and install static library
    system "cmake", "-S", ".", "-B", "build-static",
                    "-DRE2_BUILD_TESTING=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build-static"
    system "cmake", "--install", "build-static"

    # Build and install shared library
    system "cmake", "-S", ".", "-B", "build-shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DRE2_BUILD_TESTING=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build-shared"
    system "cmake", "--install", "build-shared"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <re2/re2.h>
      #include <assert.h>
      int main() {
        assert(!RE2::FullMatch("hello", "e"));
        assert(RE2::PartialMatch("hello", "e"));
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
                    "-I#{include}", "-L#{lib}", "-lre2"
    system "./test"
  end
end