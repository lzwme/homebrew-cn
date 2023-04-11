class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghproxy.com/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.04.10.00.tar.gz"
  sha256 "a6d97a5e6f6776cd3d7798bb6da0f0e117294ca2742a8fd1aac672f49e5bf764"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e4a1bc66c396ecc9c6bd65f4c0c2a295903afdc84c3d98f2af27ae92d173ace0"
    sha256 cellar: :any,                 arm64_monterey: "523a63175581e02831fbee5f3403df922082a4ab68866ad6f70b89c31022c65f"
    sha256 cellar: :any,                 arm64_big_sur:  "deb2cc279595193c7e29a3f0a1428d49f9e5c67f69bea7b4250e84849b2a658e"
    sha256 cellar: :any,                 ventura:        "bccd381d3e02ae8393c9215ce0cddb59c4a93ea9ac4b466612782fad48d1a17d"
    sha256 cellar: :any,                 monterey:       "bbdcafe617403c079550c7f38a6be98273701cf02075cea611e2ec978e84f299"
    sha256 cellar: :any,                 big_sur:        "d574b0ec268f4401ff55e5e260f5a20938cc04093e5d2e19b82db018e107a9e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ad8a392d4e7755491f5fa55c53b0a184aaabfc6eff1e9e60682534c7f8ae994"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace "eden/common/utils/test/CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 30)"

    system "cmake", "-S", ".", "-B", "_build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <eden/common/utils/ProcessNameCache.h>
      #include <cstdlib>
      #include <iostream>

      using namespace facebook::eden;

      ProcessNameCache& getProcessNameCache() {
        static auto* pnc = new ProcessNameCache;
        return *pnc;
      }

      ProcessNameHandle lookupProcessName(pid_t pid) {
        return getProcessNameCache().lookup(pid);
      }

      int main(int argc, char **argv) {
        if (argc <= 1) return 1;
        int pid = std::atoi(argv[1]);
        std::cout << lookupProcessName(pid).get() << std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cc",
                    "-L#{lib}", "-L#{Formula["folly"].opt_lib}",
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lboost_context-mt", "-lglog", "-o", "test"
    assert_match "ruby", shell_output("./test #{Process.pid}")
  end
end