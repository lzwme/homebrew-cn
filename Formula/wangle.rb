class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghproxy.com/https://github.com/facebook/wangle/releases/download/v2023.04.10.00/wangle-v2023.04.10.00.tar.gz"
  sha256 "9a70ace31aaa175a98fd19ede3feddf9121ccc359c217a57fa7b515b5dd82ef4"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "97f7bca10c660e3d223187ccd271538e60dee17bbac2167949a38bf7f1ef8897"
    sha256 cellar: :any,                 arm64_monterey: "279a8c09687879f63f721fee48a5fe95760b46ef5a1983088f0b762ed49f8b34"
    sha256 cellar: :any,                 arm64_big_sur:  "3febd2c7fdae831302a22ed235e872b5973baec0f60808cf96c56769b33191d7"
    sha256 cellar: :any,                 ventura:        "5d5b89896b0aa7977eaa8a3e320c578bee375f8162a0f3f267ba6702e33df7e1"
    sha256 cellar: :any,                 monterey:       "12bc0154a98e80df85f9c91c49bd0b90cdb65af3c680f6d3363ab04967b1f21c"
    sha256 cellar: :any,                 big_sur:        "104390a5a1165fe7010a833bc701959a1c9bbe444ea68a159f91a27049b3b63c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0f22c6405c277ed2412deb2be374ed8d23bc5ac37785e66e5c8fc4a654f45e3"
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