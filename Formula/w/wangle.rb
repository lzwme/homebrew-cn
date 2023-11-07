class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghproxy.com/https://github.com/facebook/wangle/releases/download/v2023.11.06.00/wangle-v2023.11.06.00.tar.gz"
  sha256 "9d0ef49df95dbd1b8d600e39e404c3557a9301de8731fe27fbc2ff24dac3a770"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "331b7e960b93a7cd798e7683dc08b96f331f15eb1624eaf610e50bf7b2b42a71"
    sha256 cellar: :any,                 arm64_ventura:  "373d20e85d6de9a43c092b4eb74b06ed49dbbc7c9eaa8deac2e61b4db33462b2"
    sha256 cellar: :any,                 arm64_monterey: "6186deaf6d3cdbeb0a622c01fa7d1c466a1307d67259c8784782f853873225a5"
    sha256 cellar: :any,                 sonoma:         "df6f0a8ad703feff40cb207784c9114e64a3544f4728b235e185a106e76dd4d7"
    sha256 cellar: :any,                 ventura:        "265efc45abdeae6c89d009f711f81a74d05d5ca11bbf54f453e90e164d840fda"
    sha256 cellar: :any,                 monterey:       "277d7d49bd45bce22d7f0fe3aa57279ca1428f1e08e3c489b9b5f7f9ef255e4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "088a12c89afe5a6cb4e0addf675f1a994d02b9db09773534316a77a5f45769c4"
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