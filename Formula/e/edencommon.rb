class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https:github.comfacebookexperimentaledencommon"
  url "https:github.comfacebookexperimentaledencommonarchiverefstagsv2024.06.10.00.tar.gz"
  sha256 "2b3b749e0b4457f90f9ccd08d6bb49de4abeb38f29311f60cd2af689da4f4424"
  license "MIT"
  head "https:github.comfacebookexperimentaledencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e19bb1fb91b01acc1495bafac654b95631c0033a59f7d0372fd1d8680895a1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ff2e0628742c39da8ec809a0684dcae2d2bc2b64343bb7627d6fc7983518f62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4cb3ae13f5634b8be85084e657484a7ba83a7f38ae07b176426081e0cf24dae"
    sha256 cellar: :any_skip_relocation, sonoma:         "1506cdd2d59fc998b914a756eee1d16aec30a2004575d278575bbc34c1295eb3"
    sha256 cellar: :any_skip_relocation, ventura:        "dd7b98b46b736021fd22315cad5a6d055302f02f4744109f6f91f538fafbf0a5"
    sha256 cellar: :any_skip_relocation, monterey:       "55cb24046ae863909705816c3a699940915692366581e370cd21f0b3b791c43d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77f2fcc698f755fec5dba007b35181660f9f2f80177730da073af109276b69ea"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "mvfst"
  depends_on "openssl@3"
  depends_on "wangle"

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

    system "cmake", "-S", ".", "-B", "_build", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath"test.cc").write <<~EOS
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
    EOS

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cc",
                    "-L#{lib}", "-L#{Formula["folly"].opt_lib}",
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}", "-L#{Formula["fmt"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lfmt", "-lboost_context-mt", "-lglog", "-o", "test"
    assert_match "ruby", shell_output(".test #{Process.pid}")
  end
end