class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://ghfast.top/https://github.com/google/re2/releases/download/2025-11-05/re2-2025-11-05.tar.gz"
  sha256 "87f6029d2f6de8aa023654240a03ada90e876ce9a4676e258dd01ea4c26ffd67"
  license "BSD-3-Clause"
  revision 1
  version_scheme 1
  compatibility_version 1
  head "https://github.com/google/re2.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(\d{4}-\d{2}-\d{2})$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "63ad6a1bceccd17c8ffc32bb7debe2122be80b0806e2c446b2cfbfeb18e1c621"
    sha256 cellar: :any, arm64_sequoia: "a2423c162910aac7eaf963bf761393d36166a0c8a5507984f060a17bc40d512d"
    sha256 cellar: :any, arm64_sonoma:  "56f09f301c4ff700484a77eb27d7e6d3c289b325af75c4c4e07bfa16b92b7fca"
    sha256 cellar: :any, sonoma:        "4b181e824ddfa7134cd95e0a991cb0410fae1347f0312e473b0c8296ccd928e8"
    sha256 cellar: :any, arm64_linux:   "749f6638b3fe82a6d52b74b72dfc4bc0cee5e46328bbe4512e2d9d3938764716"
    sha256 cellar: :any, x86_64_linux:  "af08193f481263ab9ca6aefb253270138c1dbff15b7f18a23514a5687405d364"
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