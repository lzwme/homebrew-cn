class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https:github.comfacebookexperimentaledencommon"
  url "https:github.comfacebookexperimentaledencommonarchiverefstagsv2024.04.08.00.tar.gz"
  sha256 "0c92545d95e996c7c9c42e0f0b1c66133aea7d1763df089028951964205c3154"
  license "MIT"
  head "https:github.comfacebookexperimentaledencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "70515596e0ea62e2c5c3091f22c567f567823fe9d0ac7678b580fd65f5480e6d"
    sha256 cellar: :any,                 arm64_ventura:  "6d2cd382a39188b19fdbfed8c14fba0d857efc042108534740801b2bf05af394"
    sha256 cellar: :any,                 arm64_monterey: "99648707fb9834ddf6b206175048f6599fbf8c21ef8000842f66bb4796fa568f"
    sha256 cellar: :any,                 sonoma:         "42162219cc34233cae6317553be766cca401d613a281e08028245f70b576eea0"
    sha256 cellar: :any,                 ventura:        "8fe891e924201053ff905d453046d0999ad50ba87840dec8f2e9e12365a9469f"
    sha256 cellar: :any,                 monterey:       "dac0434653ba151010da0e788fc6bdf6364580c5311bd08abf026e243301611c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a3da08f8b91ec260225deb969759d28b6328e3c1b4893368657c847c813b998"
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