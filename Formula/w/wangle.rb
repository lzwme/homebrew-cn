class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghproxy.com/https://github.com/facebook/wangle/releases/download/v2023.11.27.00/wangle-v2023.11.27.00.tar.gz"
  sha256 "639c0dd6200b51e36ee1e4d60fab4721aff6bfe7e1971240c69a7aec323c831d"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fa73572499208aa4de274213618ca1fe30bc6d5685a54dd5bf0c85c39d730700"
    sha256 cellar: :any,                 arm64_ventura:  "9eae08d570d829ba42f12bbee18bee72e78392d8af77855f9256493aa0cea4d5"
    sha256 cellar: :any,                 arm64_monterey: "6fd7a2b88ca08d06659ae7292e2d10e8a9c3ebb317c72186460488e91eed666f"
    sha256 cellar: :any,                 sonoma:         "3a28b86e773b7f11fbc9bd1d1fbde25267788043f23f88627ff0e73ddf28ba4a"
    sha256 cellar: :any,                 ventura:        "62c4dfa5e9465e6fb4c99a172273bf3914c2f47d1c3ba121091dbddffd9bb965"
    sha256 cellar: :any,                 monterey:       "cff2ac4bed7d7f839795ee0093502b76fa4ea44085597f08c6399f228ea851f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f1ed50d81d3a79d770404372a20ff71f0d9d97cdcf478b1a47fa7eae4e661f2"
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