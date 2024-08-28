class Wangle < Formula
  desc "Modular, composable clientserver abstractions framework"
  homepage "https:github.comfacebookwangle"
  url "https:github.comfacebookwanglearchiverefstagsv2024.08.19.00.tar.gz"
  sha256 "40eea6f5359dd8f33a5a5d9c93adac4e67ac7345f8a3dcc8c67ca8102275af25"
  license "Apache-2.0"
  revision 1
  head "https:github.comfacebookwangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "97fe899dc15daf7fee3a1bd26790fd3533f2fa6db45c46b675539d27c65f7bde"
    sha256 cellar: :any,                 arm64_ventura:  "c760e2507b15a88d1d7c9ad42e0adc4813580b0afb376e7d56354327a84fce0b"
    sha256 cellar: :any,                 arm64_monterey: "40cf3a291a48b58d5d54046d1307e15cc7454dfeb9273ecfbd27c77bb3bd7189"
    sha256 cellar: :any,                 sonoma:         "df7da8408c6b25ee48e82284cdf1ac1586cea1b1ab10598a4a1221f73db3669a"
    sha256 cellar: :any,                 ventura:        "d28898106199085ddbe626155fcca90a334abadbe24af9c60b8183aeb2808d90"
    sha256 cellar: :any,                 monterey:       "9dc1bbc1499022ccd5b3de9e1e8aceb46d3b8fd85611c3d8fe3381d72fefaa6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef98d9b85a827893fc49cefde76a31e65386f53e0e141673d0902573adb1439e"
  end

  depends_on "cmake" => :build
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "zstd"
  uses_from_macos "bzip2"

  fails_with gcc: "5"

  def install
    args = ["-DBUILD_TESTS=OFF"]
    # Prevent indirect linkage with boost, libsodium, snappy and xz
    linker_flags = %w[-dead_strip_dylibs]
    linker_flags << "-ld_classic" if OS.mac? && MacOS.version == :ventura
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,#{linker_flags.join(",")}" if OS.mac?

    system "cmake", "-S", "wangle", "-B", "buildshared", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "buildshared"
    system "cmake", "--install", "buildshared"

    system "cmake", "-S", "wangle", "-B", "buildstatic", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "buildstatic"
    lib.install "buildstaticliblibwangle.a"

    pkgshare.install Dir["wangleexampleecho*.cpp"]
  end

  test do
    cxx_flags = %W[
      -std=c++17
      -I#{include}
      -I#{Formula["openssl@3"].opt_include}
      -L#{Formula["gflags"].opt_lib}
      -L#{Formula["glog"].opt_lib}
      -L#{Formula["folly"].opt_lib}
      -L#{Formula["fizz"].opt_lib}
      -L#{lib}
      -lgflags
      -lglog
      -lfolly
      -lfizz
      -lwangle
    ]
    if OS.linux?
      cxx_flags << "-L#{Formula["boost"].opt_lib}"
      cxx_flags << "-lboost_context-mt"
      cxx_flags << "-ldl"
      cxx_flags << "-lpthread"
    end

    system ENV.cxx, pkgshare"EchoClient.cpp", *cxx_flags, "-o", "EchoClient"
    system ENV.cxx, pkgshare"EchoServer.cpp", *cxx_flags, "-o", "EchoServer"

    port = free_port
    fork { exec testpath"EchoServer", "-port", port.to_s }
    sleep 10

    require "pty"
    output = ""
    PTY.spawn(testpath"EchoClient", "-port", port.to_s) do |r, w, pid|
      w.write "Hello from Homebrew!\nAnother test line.\n"
      sleep 20
      Process.kill "TERM", pid
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNULinux raises EIO when read is done on closed pty
      end
    end
    assert_match("Hello from Homebrew!", output)
    assert_match("Another test line.", output)
  end
end