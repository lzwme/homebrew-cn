class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://ghfast.top/https://github.com/google/re2/archive/refs/tags/2025-08-12.tar.gz"
  version "20250812"
  sha256 "2f3bec634c3e51ea1faf0d441e0a8718b73ef758d7020175ed7e352df3f6ae12"
  license "BSD-3-Clause"
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
    sha256 cellar: :any,                 arm64_sequoia: "a7182a8211d8f0d30d38503b03ffadfedf0304438d2ecd23674bbc9d9d298e5a"
    sha256 cellar: :any,                 arm64_sonoma:  "c71c8494ba9c545ff24096ae88b5cfeaad7379b57cef3c7df1bf2579eca732b2"
    sha256 cellar: :any,                 arm64_ventura: "d0ea6f30ecb696a46236c3c751a720d3d825f33e3c44c673d560bcbdcef862a5"
    sha256 cellar: :any,                 sonoma:        "7b9f24faf1f35e8865728857d263a6a1e45219fa0678f6541f2dd18be7caa938"
    sha256 cellar: :any,                 ventura:       "4fa9f1d4541a56203882b898447d954098e5ac4b3cfdd03a216d8d40cb203d4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "978ec1c836041e61f299ec89eff08217dc32633b1ecc325c55c69bd259cb550e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98d4327a4e7e8b59d106490e59d1e8b74dc15ce3a3c474e55db64f52c0bb1c02"
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