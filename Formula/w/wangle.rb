class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghproxy.com/https://github.com/facebook/wangle/releases/download/v2023.11.13.00/wangle-v2023.11.13.00.tar.gz"
  sha256 "2ce2a4807d406309924c8d70254a84fa3a63e550e6697b0d61041b5d982b7d40"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "886bdd3b294b632640f40ebe056f7587f7fd9e0798cd4e459364f44b185455c8"
    sha256 cellar: :any,                 arm64_ventura:  "501f97dda8d23f539c4d48af8d66b06bfeaa031c5c4894448ae8da6740331833"
    sha256 cellar: :any,                 arm64_monterey: "20f4b7ab92ecab1a221c196a15cb84e0ae111ac1826b9567cd391ac910c82d3a"
    sha256 cellar: :any,                 sonoma:         "3ea8b1f02c11fcbca7e18ed126095e4f892bbeebe0507db888de40126c28099e"
    sha256 cellar: :any,                 ventura:        "064769d2d11dddc559e999677ab38a6f3cfe046e2e9167d1ea0ee543c21afb5b"
    sha256 cellar: :any,                 monterey:       "8bc10446a97773c946f191ce29744134370f58aabca1db050b9f33c6c28904a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e362d9460ef79cdded0bbe465a3eb3569f5aed051454dc74c0dad9979ba9022"
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