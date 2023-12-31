class Libobjc2 < Formula
  desc "Objective-C runtime library intended for use with Clang"
  homepage "https:github.comgnusteplibobjc2"
  url "https:github.comgnusteplibobjc2archiverefstagsv2.1.tar.gz"
  sha256 "78fc3711db14bf863040ae98f7bdca08f41623ebeaf7efaea7dd49a38b5f054c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ba344263f90c949f7be3cf48ac100e83eb0fe062f5b770cd688b2b84b6f3ece4"
  end

  depends_on "cmake" => :build
  # While libobjc2 is built with clang, it does not use any LLVM runtime libraries.
  depends_on "llvm" => [:build, :test]
  depends_on "pkg-config" => :test
  # Clang explicitly forbids building Mach-O binaries of libobjc2.
  # https:reviews.llvm.orgD46052
  # macOS provides an equivalent Objective-C runtime.
  depends_on :linux

  # Clang must be used on Linux because GCC Objective-C support is insufficient.
  fails_with :gcc

  resource "robin-map" do
    url "https:github.comTessilrobin-maparchiverefstagsv1.0.1.tar.gz"
    sha256 "b2ffdb623727cea852a66bddcb7fa6d938538a82b40e48294bb581fe086ef005"
  end

  def install
    (buildpath"third_partyrobin-map").install resource("robin-map")

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Change Objective-C header path which assumes tests are being run in source tree.
    inreplace ["TestTest.h", "TestTest.m"], "..objc", "objc"
    pkgshare.install "Test"
  end

  test do
    # ENV.cc returns llvm_clang, which does not work in a test block.
    ENV["CC"] = Formula["llvm"].opt_bin"clang"

    # Copy over test library and header and runtime test.
    cp pkgshare"TestTest.h", testpath
    cp pkgshare"TestTest.m", testpath
    cp pkgshare"TestRuntimeTest.m", testpath

    # First build test shared library and then link it to RuntimeTest.
    pkg_config_flags = Utils.safe_popen_read("pkg-config", "--cflags", "--libs", "libobjc").chomp.split
    system ENV.cc, "Test.m", "-fobjc-runtime=gnustep-2.0", *pkg_config_flags,
                   "-fPIC", "-shared", "-o", "libTest.so"
    system ENV.cc, "RuntimeTest.m", "-fobjc-runtime=gnustep-2.0", *pkg_config_flags, "-Wl,-rpath,#{lib}",
                   "-L#{testpath}", "-Wl,-rpath,#{testpath}", "-lTest", "-o", "RuntimeTest"

    # RuntimeTest deliberately throws a test exception and outputs this to stderr.
    assert_match "in flight exception", shell_output("#{testpath}RuntimeTest 2>&1")
  end
end