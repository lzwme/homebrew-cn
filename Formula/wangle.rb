class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghproxy.com/https://github.com/facebook/wangle/releases/download/v2023.05.15.00/wangle-v2023.05.15.00.tar.gz"
  sha256 "2b12abd6c17319ec6f648bdcb4f6516e08044282aa77aad455447b3a01c2b22f"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6d6627503a6bfb858f2a7963eb9bbb3a589783abfeab7db8059aab2caba12ff1"
    sha256 cellar: :any,                 arm64_monterey: "c5161fd658983a3f32b844e5d6a64bd762d0c8e93a3f4202842a8941fe933a07"
    sha256 cellar: :any,                 arm64_big_sur:  "16fb5c736d7718e7d4e5a652c211bea7454360e47df6fa17a2d1afa8cbd153dd"
    sha256 cellar: :any,                 ventura:        "e72a0c31363125fd53eca25e4bb5139e46ecb6edf2b44c23102801bd550bbd8b"
    sha256 cellar: :any,                 monterey:       "0104c8e2f303b03ac9a3a23d9beeafb8cdcabce5ed8f3c38c64fa01ecf9993d5"
    sha256 cellar: :any,                 big_sur:        "27cbe6b8258020809666289e4fda3bfffbdb8b2c759cd5d1e11c94dbcfa6f070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4a913c0503d23c81da94aff1bab0b60236eeb163e7c9cc1a9c7d668ad8167dd"
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