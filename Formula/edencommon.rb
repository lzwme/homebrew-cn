class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghproxy.com/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.07.10.00.tar.gz"
  sha256 "73eb95578acf4ed5771ce49ce60fc2a8c8cdb59cf0d54501871ece47cc7e0eed"
  license "MIT"
  revision 1
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3cf2b6c62e8b7d0dcd35343f48c272754771546c7668f3795e786c64a74edf09"
    sha256 cellar: :any,                 arm64_monterey: "b083c06a258f078f59c3b51769f70bcc67717f232a899fe7e70695d9eeb9b20d"
    sha256 cellar: :any,                 arm64_big_sur:  "ad0efd9c4695c475d82b5aa759fac4a986dbe9b38bcca751ac015c4d99a4b910"
    sha256 cellar: :any,                 ventura:        "4987abbf0ac3e81d332e0f6f536e388bba5b78b360db0ff279650387fe193692"
    sha256 cellar: :any,                 monterey:       "cdd6634166fbad398c479f8aa3e3bc2acb892e3a0eff4f762bfe96270e3941b7"
    sha256 cellar: :any,                 big_sur:        "dd08fe923ff53bb35e0a7c3d1983f3b13cacc32299152d5c075b393c87a4021a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e3ba9069e85f6ba39a0ccd3dd05b0152875a1b6e7ba38c404acb58879250d84"
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