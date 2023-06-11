class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghproxy.com/https://github.com/facebook/wangle/releases/download/v2023.06.08.00/wangle-v2023.06.08.00.tar.gz"
  sha256 "c0540e9e2bb77e79c394b70f3b75ea352e3ca2f969360bbe21df99ae30184a3c"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cddf7813c3ee65eefb2363efdfba9b209a26e2fc9561244b0c53ce45dc708231"
    sha256 cellar: :any,                 arm64_monterey: "73c302402686adb6af530619e55e5593d2c098406b0ceb5ef38a942ddd2f36f7"
    sha256 cellar: :any,                 arm64_big_sur:  "6de0d496ab1da54f6e3ed626da6eae897eafec14a5d3194ec2f143cbb70c824b"
    sha256 cellar: :any,                 ventura:        "2404fd116300b41bff2594f9fd1327701d9e1d3ff57ac760a3c912358b7b500d"
    sha256 cellar: :any,                 monterey:       "e96503bb8d8329c88ebbacacaaeb737b75535f87790f8b3b6d3d701af0e77a07"
    sha256 cellar: :any,                 big_sur:        "b3884ba86b5997bd95b75296daa404e70dcf7244d036ab43c3842fd04a3bba5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fc87926788cdc0893cdd43adf75d45ab9d05280e204e8b56775c1f1284356e8"
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