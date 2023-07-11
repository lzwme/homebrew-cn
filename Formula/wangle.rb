class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghproxy.com/https://github.com/facebook/wangle/releases/download/v2023.07.10.00/wangle-v2023.07.10.00.tar.gz"
  sha256 "44009745712347639ea037819c546f07946c9e6346e3f13bf922688daa276456"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d21066b5d4c533e3ff1ea7da10c78a5c422ffb5fb03ad969995ae83737c76c35"
    sha256 cellar: :any,                 arm64_monterey: "299bfd5a3b06da80540b8503eb38a6b8f4ab0474f924e2fee3879ce2eaa9ad9d"
    sha256 cellar: :any,                 arm64_big_sur:  "0c499016c6dead7636b2c68950a94bca2d2cfa3b005f3706f45487eb29092c33"
    sha256 cellar: :any,                 ventura:        "00a7e88c865f6cd62b5984f81aad366136778868135f1f63992c767ac2d7471a"
    sha256 cellar: :any,                 monterey:       "209af50e2fb172a53e677f61e3b1cfc6a1392689c40800b35127d17db80a201c"
    sha256 cellar: :any,                 big_sur:        "ed8eeb6a7d22073db041c67f63ac9fe56ca324fa795a9ad66c96664b1b015d70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b0b6133f17cdfdcd30ed072e24116a9e48ed59f10392e2d8ee757af8f08d900"
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