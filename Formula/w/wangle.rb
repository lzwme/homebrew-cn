class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghproxy.com/https://github.com/facebook/wangle/releases/download/v2023.08.28.00/wangle-v2023.08.28.00.tar.gz"
  sha256 "493d38492adb5fd5d7544f8df47ea4b7ef5bac16747823aed4abb91aa3e7f7d1"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0df8be403996a205aadcba426e13eab02d6aa8d7434378ddd57fa63c8f3ad9f2"
    sha256 cellar: :any,                 arm64_monterey: "fffc3a9d89bbc476bdad888fe2bb02f9aed31ad189f8c57cf3f1ba026205061b"
    sha256 cellar: :any,                 arm64_big_sur:  "fe6df4b5b12d13dead1c2e5021b215ad753fb3233c65fbdc9abb54aef581a2a7"
    sha256 cellar: :any,                 ventura:        "61f20e58f7873c854fa05abe1de6d52075c9a0b71272daeec328a3d88abfe2e3"
    sha256 cellar: :any,                 monterey:       "48428f00c9356f5351ea839b6d1329324d8f356c9e1541f2becb28caa02e1a0f"
    sha256 cellar: :any,                 big_sur:        "b13a9bda6f4689d0b2b51200d126c925fe917f7d0e368f87b8b742a96c165468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0cb7f8a8590ee85f784bf83b85c091b3353ea319e6e6ef53e2c5420fb725bff"
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