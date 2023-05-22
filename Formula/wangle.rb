class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghproxy.com/https://github.com/facebook/wangle/releases/download/v2023.05.15.00/wangle-v2023.05.15.00.tar.gz"
  sha256 "2b12abd6c17319ec6f648bdcb4f6516e08044282aa77aad455447b3a01c2b22f"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d79a52046445b652d14517882048f434f0ad1417423a28b474f215b56dde00d1"
    sha256 cellar: :any,                 arm64_monterey: "b88e652b69abd063ac9da02854932becfdacf5a0150c8e21028b44205ea29ed9"
    sha256 cellar: :any,                 arm64_big_sur:  "1af83913e350dae908c180b737c1ff8431473a6987af77100e3efdb325204e9a"
    sha256 cellar: :any,                 ventura:        "40578fa79984b98ba4297e90a4b50362c4ee8e76164ab23c18b1a0d506194a69"
    sha256 cellar: :any,                 monterey:       "93a7f4a9abdb6857be92506fa53c528b910e1fe5151a1bcc5e9015c3508da58a"
    sha256 cellar: :any,                 big_sur:        "e09d9fd5770e86cda277cbe96e2c3ff879332c1d1b70fb4c521270c01b55bad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "233687c537616f28375dc7142fff10114a4619f6ce43f16340545d1eb7c8a515"
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