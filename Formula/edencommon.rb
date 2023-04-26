class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghproxy.com/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.04.24.00.tar.gz"
  sha256 "979a6d87ac222c72429b289d2d9144d666bb5b3f0b5029c7151feb8629de2ba8"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "68c111262923cc2f3313b273df9cad3be9febb8122e44509b9f817e0a4b0f6cf"
    sha256 cellar: :any,                 arm64_monterey: "424729c95b11273d2a061398ae26d9d6cb29da37112c3d58388d9034de6a011b"
    sha256 cellar: :any,                 arm64_big_sur:  "5b973285fa1f3be0d9fae6f56fb1bae0df968c0b7ce0d422d47c690bf2af6151"
    sha256 cellar: :any,                 ventura:        "1fb2272caf6f9c141229d8dc50fb6983fffb7bdef261e8133898212100e8dde5"
    sha256 cellar: :any,                 monterey:       "e5e4f5a81c87ca4e5157d38e5850c43947a98e1358af44c920b6d345a0688dd4"
    sha256 cellar: :any,                 big_sur:        "f43ef87807fc8b7bf7a6d2ac4a043021b10ee9d8ce3f784cf707d4e7acea61c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8d2b3dbfd21623dbc69283ffb3cf2d522b81d3a6f7febbc9c91cc6ecddd8bcc"
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