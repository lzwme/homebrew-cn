class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https:github.comfacebookexperimentaledencommon"
  url "https:github.comfacebookexperimentaledencommonarchiverefstagsv2024.04.22.00.tar.gz"
  sha256 "6b558e3f78fb6e211e26c6e7a07b2b5a9073322b39c60afc3def21309b360053"
  license "MIT"
  revision 1
  head "https:github.comfacebookexperimentaledencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a87b5163959d6d4fa9083b0b0775788759caeed77cfb96340194828f7739c8eb"
    sha256 cellar: :any,                 arm64_ventura:  "1f4da008d9d19afa58492b4c5b2dd11f060ce534929cff44be37ca6eb8639629"
    sha256 cellar: :any,                 arm64_monterey: "8e6ee43948614fbf6c855fcde7db293644a2120c3d506735aa351e6358781696"
    sha256 cellar: :any,                 sonoma:         "ad4a2465610abc9337107c351822fa9101d283484b9e88a611cba0e3d405b854"
    sha256 cellar: :any,                 ventura:        "f101c96bfc7adab1e2446ec363c3c78d1625458a80313a98314b898b266b49ef"
    sha256 cellar: :any,                 monterey:       "def2d424178794452438d9b51c75c176a525b6bdd3f11bb47efd458fdd7b83ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bea724452a93add7a69fb6f0303ad9508ac6e9785f102838b053aa3acef5c5bd"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
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