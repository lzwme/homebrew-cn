class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghproxy.com/https://github.com/facebook/wangle/releases/download/v2023.04.24.00/wangle-v2023.04.24.00.tar.gz"
  sha256 "93af6fe4e3ffc98869f5f7b5352aac3b7fd92963f5f7c801c2778b8ad8594550"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d64bb28985d86ec8294b9e8667c0ee55720d92cb57d289c3a32b2708a871ac87"
    sha256 cellar: :any,                 arm64_monterey: "e7a73a6a52708c20c5963243c4d77a02dc7f57dce4c88331e75b9de4a93af131"
    sha256 cellar: :any,                 arm64_big_sur:  "3accf75edd41e8176f1faa3ce58d89f3852e25e2da9bb1350519333577d657fe"
    sha256 cellar: :any,                 ventura:        "e5b5dbaec81c176a0933fe8dfdc8ddf696ebd6f1f646b2a509ae2612da9106e1"
    sha256 cellar: :any,                 monterey:       "8b62662a85672d7d2690d05f2332781c5606641a67f01ac497b963bacd8c860e"
    sha256 cellar: :any,                 big_sur:        "d2dc8f6a3084f4711e6838e3cd891eb33041b59d405fc150a4e7c2989006f8f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f34af747aeb3562f6bc7a5a800302b86f0b45f300153b61bd3416e31f6264a3"
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
  depends_on "openssl@1.1"
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
      -I#{Formula["openssl@1.1"].opt_include}
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