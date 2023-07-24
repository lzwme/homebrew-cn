class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghproxy.com/https://github.com/facebook/wangle/releases/download/v2023.07.17.00/wangle-v2023.07.17.00.tar.gz"
  sha256 "8e94e4c593889ad71d076a621da4c41071d0d72b665b89448de490e7c13554fe"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b07971568aa570f109345f0cddd6fc39f5efbb4af9e84bd46ff0c62e72d0406c"
    sha256 cellar: :any,                 arm64_monterey: "7c6dcb209e28325cc4d4fef0d2d7eb0e7e26575b37a00aff2b92d115ca066a2b"
    sha256 cellar: :any,                 arm64_big_sur:  "c7e458c3d8f762346533d3396d34447a7ad84a975bd6cfd4f677017d30b0611c"
    sha256 cellar: :any,                 ventura:        "48588425cb96fd71ea65e72d0b71b731ceb0dd7675f357606e68c6897ada6314"
    sha256 cellar: :any,                 monterey:       "384264548b861cd1e87bde07b6219892a1a0ece1a9af599bad1899b9e5fa48fe"
    sha256 cellar: :any,                 big_sur:        "fb7bdf8601c25d4b2b59dd6d661a4caa461b01859183e1dc81f2714e830c0649"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c17d20fd38617d2c86905c52e9a9a78900b52a85738a53d7167e1d034d9ae149"
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