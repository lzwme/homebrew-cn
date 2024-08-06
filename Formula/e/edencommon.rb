class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https:github.comfacebookexperimentaledencommon"
  url "https:github.comfacebookexperimentaledencommonarchiverefstagsv2024.07.29.00.tar.gz"
  sha256 "f645aefed481dbf6b0e71921336191bdbb06cf4b265b5d62f30ba657468a4012"
  license "MIT"
  head "https:github.comfacebookexperimentaledencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fa1681a940782be166682d9e4871ceb0d34781466b09118da2de749c9776973b"
    sha256 cellar: :any,                 arm64_ventura:  "b07eb1020d0029e9862f0e6055a35c7e8b843ce7cf31bdfbcd627e941e7c304b"
    sha256 cellar: :any,                 arm64_monterey: "4ff0359bcfa85a1a10392c4f0d802b5f225fd5d97a3428709bd5851e1d3a062c"
    sha256 cellar: :any,                 sonoma:         "f1da2e5d83a2c3d109691a1a2fb4624d1e94f7f96f3f7317826efdbcd5a59742"
    sha256 cellar: :any,                 ventura:        "0b68f8c97712821e43ac9963ae7b78a98d5ab232b0cf29f2a61e5aa4b3771431"
    sha256 cellar: :any,                 monterey:       "e7802956f71a4c9a6144ae00c2daaf8af6d3b2174ff5b16796862e87611bfce5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bfd72ec2d9e10acc06686fc126865741c1ffae1db79912bcaaaf461a0d03496"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "wangle" => :build
  depends_on "boost"
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  # Build shared libraries
  # https:github.comfacebookexperimentaledencommonpull20
  patch do
    url "https:github.comfacebookexperimentaledencommoncommit01bca703032ff108665a83274fb56617b46882aa.patch?full_index=1"
    sha256 "50f704ad44aa6fa8df35d913966c5c28f8fddb8871b35b3420875c804efc386a"
  end

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