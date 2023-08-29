class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghproxy.com/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.08.28.00.tar.gz"
  sha256 "920f208fb85defcde928599a87fd7bcef5ba1be3592a95f39277a541a11e6cf9"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b9a8b424b663c8040cd31c732c4b97ba57ae8dd9af0e98944310e08ff2e3a2ad"
    sha256 cellar: :any,                 arm64_monterey: "4f18f5d03d5c1f0f1f840d84e6746b0e4976fb9991cd7eae4fa2012600c8d7e1"
    sha256 cellar: :any,                 arm64_big_sur:  "fb64b73cf0fea60058cb988c8b4f85c03403eb57b9c7d1b3e43f478a5113100b"
    sha256 cellar: :any,                 ventura:        "b8413e78102455c2477b14e889a10fd62118c9260cddbf43a0e8d3bbcdf0be8e"
    sha256 cellar: :any,                 monterey:       "daf80746e569b261e2205c6612aba6852c36e82a7253c19b5a4c7a91ca2bf463"
    sha256 cellar: :any,                 big_sur:        "c29cc0ef3b006016524903fd0ab11e75c1ff26cc326fba27e60e46c9aad71534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38a3116ec6384cc8b7ff48705e28d3b56198c044037b4056b7e09138cef132a6"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  # Fix linkage against folly
  # https://github.com/facebookexperimental/edencommon/pull/10
  patch do
    url "https://github.com/facebookexperimental/edencommon/commit/b162c1b8d94b4ed49835da6d03b4d0a550082b47.patch?full_index=1"
    sha256 "99c299fa6df887d1e72aed3d60a8ca32eb2eda1897715482af8ddfa4702fe24c"
  end

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace "eden/common/utils/test/CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

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