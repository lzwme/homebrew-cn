class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghproxy.com/https://github.com/facebook/wangle/releases/download/v2023.10.02.00/wangle-v2023.10.02.00.tar.gz"
  sha256 "26cf0656be1dee03f7a6a328f21a30f049ad12931a780cd6d1b59dae815b77d2"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e675e532ff6ff08a1ed2c23b9a4dd21676c016fc206e9b86da0232861dd789b4"
    sha256 cellar: :any,                 arm64_ventura:  "d49f6583a6c7acc5ef349fef3ca6e1019cdf479431ec31d8e1b1082fc071e3e3"
    sha256 cellar: :any,                 arm64_monterey: "3a9a07b7c1fe18a57f082b424d78ec91ed7c438d3c482217d28fe96e9ac0b0f0"
    sha256 cellar: :any,                 sonoma:         "7c93ee7c1f4538efdf641f216458b06d901689cfb34fa2965a44a31148cde798"
    sha256 cellar: :any,                 ventura:        "804c82868c864b36d82943617f205e0fa22bd936a427a676ef0748231a6b423f"
    sha256 cellar: :any,                 monterey:       "22bbf97ff874c4245fd5d1f4dcdb452ecc1e7dceebf3acd1cb6d5c61c3885df2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59c7337ba9e4fa6ee5e588aa64191e1fc7e9b46c77a0a407592b3b5d2eefe898"
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