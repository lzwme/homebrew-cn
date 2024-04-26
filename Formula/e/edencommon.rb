class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https:github.comfacebookexperimentaledencommon"
  url "https:github.comfacebookexperimentaledencommonarchiverefstagsv2024.04.22.00.tar.gz"
  sha256 "6b558e3f78fb6e211e26c6e7a07b2b5a9073322b39c60afc3def21309b360053"
  license "MIT"
  head "https:github.comfacebookexperimentaledencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3bd211895e5d6256b6ee9a5e169beb8b9844545994f7998a824023736157e319"
    sha256 cellar: :any,                 arm64_ventura:  "3d3c5993d9322d50737f542975ad8a1877d4d307c2d8660767209313ba0ed523"
    sha256 cellar: :any,                 arm64_monterey: "ae94de512c1b8748025f18f1b0ec373c447a2d1bc53972713ed78853d3e3c4fd"
    sha256 cellar: :any,                 sonoma:         "39d84fa6a87ba405a9d26321bbfaa3930b9885286e511eda4273946c34a21fe6"
    sha256 cellar: :any,                 ventura:        "6c57afc9e37b385e73ddc7d41e6c1eb32d724148fdd54e2e0a76241c9642bc13"
    sha256 cellar: :any,                 monterey:       "1305fd75249232d9a4125adcef96d37f673acc39e58c28e4c34150f52537bcae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23408041b7039074d84d2d6a873b5dd56efe29407c23bd568d2b3b210ed6e8c7"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "wangle"

  # Use AUR's patch from open PR to fix build with `fmt` v10.
  # PR ref: https:github.comfacebookexperimentaledencommonpull17
  patch do
    url "https:github.comfacebookexperimentaledencommoncommitbd46378b43aaa394094799d18f734495385c6f67.patch?full_index=1"
    sha256 "74b47722dd7d40cb07fc504e9f14dd18fe6ee7c38b83373a4d94637fcb618ca1"
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

    system "cmake", "-S", ".", "-B", "_build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
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
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lboost_context-mt", "-lglog", "-o", "test"
    assert_match "ruby", shell_output(".test #{Process.pid}")
  end
end