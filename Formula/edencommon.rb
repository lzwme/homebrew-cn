class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghproxy.com/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.06.12.00.tar.gz"
  sha256 "8cfd53508ba31a5a830987a7c99ecf2dc25541a76f82e836c260e6c53e4d793b"
  license "MIT"
  revision 1
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "19c66c711310e4f179cc12f708c86b3cc1e8240afaa57b53fe05ed134c0fc85b"
    sha256 cellar: :any,                 arm64_monterey: "d13b03a9a2d4c57f3634b4ae97120c33d87466f7e6787fafaa09ef693ada6a79"
    sha256 cellar: :any,                 arm64_big_sur:  "f1d592a5bbf9c01da4dd8150f1799b10ad865957a3b649a7c6878488833b0131"
    sha256 cellar: :any,                 ventura:        "a1ccf3ef2f3303732b24173d78673ecfb31c935c31b4baeda48543edf547ca2b"
    sha256 cellar: :any,                 monterey:       "6f521eee3773a72355cb8cd8244502da9bb63be2fe19ea978bbb991b7b287e46"
    sha256 cellar: :any,                 big_sur:        "c9f2c1a431664d692ccc22a89b7bf9a90d4f1062485cafd468cf5e10c2f0dd8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "989e152774513266200300500705ebbcc630eaaa096e1b2a742fb39aca50c1bf"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

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