class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghproxy.com/https://github.com/facebook/wangle/releases/download/v2023.07.24.00/wangle-v2023.07.24.00.tar.gz"
  sha256 "27b2c03099a12f652289d5621738b4f4d701f6f00e09a3cfdab51dffcc72b2d6"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2a703d37c8e2966b57be6a374e8fcf97c287052febf3191855eba8d803a6eb77"
    sha256 cellar: :any,                 arm64_monterey: "9eff40b45982177f34dd733807c480871b510f30e2e240896c40dd84f442d1fb"
    sha256 cellar: :any,                 arm64_big_sur:  "e9c691dcd04d2ceb52008a3d6fea2414c11affaf37cde1f7f0b6e5653d9b58e6"
    sha256 cellar: :any,                 ventura:        "78ccdbfd01f8155d33a198cf6083c9b5b41457a73b2010d7a08c3aea798ce0ee"
    sha256 cellar: :any,                 monterey:       "b6acd285a5bb955fd4f240bab5153e41e2cb6fb0bc4ac76702ec28e2d7e35a09"
    sha256 cellar: :any,                 big_sur:        "8846470320e7d6fb0aa3d41d0a079d54f02eaabc1cef27914edc2e9a05d4399b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e84c2e6f5fcdf3d9f16e62550b21e63c94ac774350a66682c588d1aa54b12e1f"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    cd "wangle" do
      system "cmake", ".", "-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
      system "make", "clean"
      system "cmake", ".", "-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
      system "make"
      lib.install "lib/libwangle.a"

      pkgshare.install Dir["example/echo/*.cpp"]
    end
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

    system ENV.cxx, pkgshare/"EchoClient.cpp", *cxx_flags, "-o", "EchoClient"
    system ENV.cxx, pkgshare/"EchoServer.cpp", *cxx_flags, "-o", "EchoServer"

    port = free_port
    fork { exec testpath/"EchoServer", "-port", port.to_s }
    sleep 10

    require "pty"
    output = ""
    PTY.spawn(testpath/"EchoClient", "-port", port.to_s) do |r, w, pid|
      w.write "Hello from Homebrew!\nAnother test line.\n"
      sleep 20
      Process.kill "TERM", pid
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
    assert_match("Hello from Homebrew!", output)
    assert_match("Another test line.", output)
  end
end