class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghproxy.com/https://github.com/facebook/wangle/releases/download/v2023.07.10.00/wangle-v2023.07.10.00.tar.gz"
  sha256 "44009745712347639ea037819c546f07946c9e6346e3f13bf922688daa276456"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1c7f8291dc9d68c01d3493c02d360269776008ce810d1deb4c97eec688160132"
    sha256 cellar: :any,                 arm64_monterey: "d4aa4426269a58218c2a0bcb772092eea1389a14371cc1d40ac2f55ee8d7c791"
    sha256 cellar: :any,                 arm64_big_sur:  "c5c6a85eb3d46fce4a1a408a1eec1b206f72cc9e1c1fd02588340307a68cac4f"
    sha256 cellar: :any,                 ventura:        "fa13d33d763883343d82cf494c57333f7a4a986307fd534691ea89a813f966d5"
    sha256 cellar: :any,                 monterey:       "c19cbb64a85b2815f917f3ab7759b8b8eee5fb60b245cdc90c8650c6a8d599db"
    sha256 cellar: :any,                 big_sur:        "78bbab55c9ef5ff0d9ec2686621473f1b2993d1dd5e25fb4f497ae3f7abbac53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fced2696c11f31fdd452734425ef57ad004721888eb40bec7a88dc832bf6a33"
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