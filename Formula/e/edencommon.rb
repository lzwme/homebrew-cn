class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https:github.comfacebookexperimentaledencommon"
  url "https:github.comfacebookexperimentaledencommonarchiverefstagsv2024.04.01.00.tar.gz"
  sha256 "9d7f7de1f1ff6039125c10ec0e7c36de9008705222ecf617af01a1f88b7622a8"
  license "MIT"
  head "https:github.comfacebookexperimentaledencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c88bd32974405ce76579464ac18e971bd995ef9550944e9868860a096d2b8a63"
    sha256 cellar: :any,                 arm64_ventura:  "c294b86c53810894f97fb3577acfa1d02c3c5ef73ffd7d08536b29544ba832b0"
    sha256 cellar: :any,                 arm64_monterey: "68f944285118a498d8b33b102b316b81969b30f6670feea71d95837de54a30a0"
    sha256 cellar: :any,                 sonoma:         "0795d1be1d3c0226a3e2f0f95075ca687135bc4744ac56ccb66f67578a29643b"
    sha256 cellar: :any,                 ventura:        "0754cd3afd45854c70fbb9183145203c138f72e91a9522ceb3fefe24291b66a0"
    sha256 cellar: :any,                 monterey:       "dbff73d259de36e83e6fb07b1b363d9bf230070b905d73ff421cf82c6be0feae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02b6af7087766951627635227996e39bf60b9ee0bddb35a4f5265f46b2428e61"
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