class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghproxy.com/https://github.com/facebook/wangle/releases/download/v2023.03.06.00/wangle-v2023.03.06.00.tar.gz"
  sha256 "037db6cdcbdd1c5ba1613f7ee27e04a61dcce1b19163b64d0150fc5232761c58"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ee72f85fbdc8cb61a7c5748f4f9d0cc4965027df914990ce2eb06a84e649054d"
    sha256 cellar: :any,                 arm64_monterey: "fa806ad2350c87f11b379ee24bcd01388a4d53f810af54fef433b120f9d7bd1b"
    sha256 cellar: :any,                 arm64_big_sur:  "954b2e0fa4355d759e46dd77765b521e6e965d225ab210d7b7d4de934e54c4d1"
    sha256 cellar: :any,                 ventura:        "da8298e56ca0f7422a8e0d5799bcecf900cbc3a3ff5207013d272fddddc58908"
    sha256 cellar: :any,                 monterey:       "8326fd33f70050d2db4f36a3aba7ada6a8e1b417ceb7c9d0e7a07ba061126922"
    sha256 cellar: :any,                 big_sur:        "c1d52425a6c9e3bb20a98c3dd4849d580254d90cd7eee7f9ba70d2c06afdd428"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe64e54be968ae07e81bbd396ced2d7591f17752910c2c06e69569274a0562a5"
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