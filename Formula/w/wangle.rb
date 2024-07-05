class Wangle < Formula
  desc "Modular, composable clientserver abstractions framework"
  homepage "https:github.comfacebookwangle"
  url "https:github.comfacebookwanglearchiverefstagsv2024.07.01.00.tar.gz"
  sha256 "7bea59ad6e7fb9453cf757ddcb6bff94e661bf7c81f2d60219561a3e40cb3fdc"
  license "Apache-2.0"
  head "https:github.comfacebookwangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5d377b5435b3ca9a69c3578f1705e62285ee0f3ffaeffe49d87a9b5b7f233a8d"
    sha256 cellar: :any,                 arm64_ventura:  "21b481b50fa914126c33c0a8c75f91c696ba60ae85447489bcb6fee14a667370"
    sha256 cellar: :any,                 arm64_monterey: "5301cb36a4a66de01285fbbd85501edb815993ed1ff0580c8b4537af90f2aeac"
    sha256 cellar: :any,                 sonoma:         "139f46b233ceebd98eee872490445bdee54c775ca5fedc5fd20f3d09e67642fa"
    sha256 cellar: :any,                 ventura:        "2309f61c2c614b21a7fdc57609f6ee1a440be861830e11aa0aa9b54a99ba3efe"
    sha256 cellar: :any,                 monterey:       "fc03d817f374a50be14a5c96df32bbc3ccc69feef933572399973d4b7f554ff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2a40f27774a1d00043ccbcadd4569ae04afaf2ca53d6a8f5d357dae338f988b"
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