class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https:github.comfacebookexperimentaledencommon"
  url "https:github.comfacebookexperimentaledencommonarchiverefstagsv2025.04.07.00.tar.gz"
  sha256 "f9d1440a1a1c80bb9826f5cad1f5bdd2d1a8d12c8edd75d3eb2d9b66f7dd5814"
  license "MIT"
  revision 1
  head "https:github.comfacebookexperimentaledencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f4d4d1a44ccc973c2bd3023764f1d4fa1a987b063f06f4bbf8b7db5961e2ea67"
    sha256 cellar: :any,                 arm64_sonoma:  "1af9cdae0f3d037fdd0ca65b36a9975d56fe00819a144ad15a10bdbfbad8f368"
    sha256 cellar: :any,                 arm64_ventura: "c553d8109aa177b953e31377ece42916cea5c08283612b6480bb4bb116726132"
    sha256 cellar: :any,                 sonoma:        "45bec97bb887416dd0f2ddfc44890e334a2a09ba7e17c6837c4e5b2bedd8a147"
    sha256 cellar: :any,                 ventura:       "95d8be8b80242ca92db82388f5e7c9017ae1f26ed0a779a411ae24f15791371a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32d2f5fe627ccfcc6b77942cc27dca571d5e8b522bffe574cfc8a34fc3c9b6eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e32a63f1fc6b2751545aefe7ccd4d2686128f3f0b92ef9a9931602a580520da7"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "wangle" => :build
  depends_on "boost"
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace buildpath.glob("edencommon{os,utils}testCMakeLists.txt"),
              gtest_discover_tests\((.*)\),
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"
    inreplace "edencommonutilstestCMakeLists.txt",
              gtest_discover_tests\((.*)\),
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

    # Avoid having to build FBThrift py library
    inreplace "CMakeLists.txt", "COMPONENTS cpp2 py)", "COMPONENTS cpp2)"

    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    linker_flags = %w[-undefined dynamic_lookup -dead_strip_dylibs]
    linker_flags << "-ld_classic" if OS.mac? && MacOS.version == :ventura
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,#{linker_flags.join(",")}" if OS.mac?

    system "cmake", "-S", ".", "-B", "_build", *shared_args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath"test.cc").write <<~CPP
      #include <edencommonutilsProcessInfo.h>
      #include <cstdlib>
      #include <iostream>

      using namespace facebook::eden;

      int main(int argc, char **argv) {
        if (argc <= 1) return 1;
        int pid = std::atoi(argv[1]);
        std::cout << readProcessName(pid) << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cc",
                    "-L#{lib}", "-L#{Formula["folly"].opt_lib}",
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}", "-L#{Formula["fmt"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lfmt", "-lboost_context", "-lglog", "-o", "test"
    assert_match "ruby", shell_output(".test #{Process.pid}")
  end
end