class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghproxy.com/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.11.13.00.tar.gz"
  sha256 "8f02182471106abed5fbb964af78b4de97e2f63557a78bd2691f47ab082c89c5"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e3a57702152fbf06849bd9229e9430bd79382231d20a795716ab7a3c9623b4e9"
    sha256 cellar: :any,                 arm64_ventura:  "49df244abb60af27cbecf6d93d8d8d8be6b8b42fc17ae9df926cc2b670cace6b"
    sha256 cellar: :any,                 arm64_monterey: "2a108d7291e7b7e98cedb841cac076fdf16b894c8040ea9f5b6cb84944daf9fc"
    sha256 cellar: :any,                 sonoma:         "e90a31f63a7d0f75aef03c8c3cad7da65412c636267768f77a8ce5d5d78f1400"
    sha256 cellar: :any,                 ventura:        "1acffd68443eb4d491d0c46ffbb663d8d24e63ffb551f61ae933a1a13ae3d6d9"
    sha256 cellar: :any,                 monterey:       "dd4abd9af4b5de1d61d84629eca54d1b0fc3185f294c9c8c211a198238880438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47ec3130382e6de6f24a1fbbc5677dc317d1bcd4807d38fb8ffda445fd58e2f3"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "openssl@3"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace buildpath.glob("eden/common/{os,utils}/test/CMakeLists.txt"),
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"
    inreplace "eden/common/utils/test/CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

    system "cmake", "-S", ".", "-B", "_build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <eden/common/utils/ProcessInfo.h>
      #include <cstdlib>
      #include <iostream>

      using namespace facebook::eden;

      int main(int argc, char **argv) {
        if (argc <= 1) return 1;
        int pid = std::atoi(argv[1]);
        std::cout << readProcessName(pid) << std::endl;
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