class Wangle < Formula
  desc "Modular, composable clientserver abstractions framework"
  homepage "https:github.comfacebookwangle"
  url "https:github.comfacebookwanglereleasesdownloadv2024.04.08.00wangle-v2024.04.08.00.tar.gz"
  sha256 "d38e7162a31d1d88590f6ae8151bd5ffc017cbab95b022a2acf684c5e4402ebd"
  license "Apache-2.0"
  head "https:github.comfacebookwangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c92be74b868e63ba2b360dcb06a8f12b6054f73309629efc36bf31ebc83feb02"
    sha256 cellar: :any,                 arm64_ventura:  "c78987abebaf0a16a2e2f6e3bdc6d18b08d611213a9ece5dadf67a3590ff43cb"
    sha256 cellar: :any,                 arm64_monterey: "e118914ca5920897400f04cbb27bc8ddbc878563deb232001a25b4a940a80742"
    sha256 cellar: :any,                 sonoma:         "0c853a39b00e96f7c0e6e8106cd90902fcc24444b1b6b0eb1d13fdddc2905b2a"
    sha256 cellar: :any,                 ventura:        "1a378c4f0702597b6d98b17a206b4abd2b6819c7f8c098016bd52be786a4dd6b"
    sha256 cellar: :any,                 monterey:       "553601526bda9311ebfc147ad49780371370829fc57acc3e4d462d6c6541455b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b107189347b4391d35b22c4ead55f8186035e50067ac96ee75cccb02683dcc9b"
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
    args = ["-DBUILD_TESTS=OFF"]

    system "cmake", "-S", "wangle", "-B", "buildshared", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "buildshared"
    system "cmake", "--install", "buildshared"

    system "cmake", "-S", "wangle", "-B", "buildstatic", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "buildstatic"
    lib.install "buildstaticliblibwangle.a"

    pkgshare.install Dir["wangleexampleecho*.cpp"]
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

    system ENV.cxx, pkgshare"EchoClient.cpp", *cxx_flags, "-o", "EchoClient"
    system ENV.cxx, pkgshare"EchoServer.cpp", *cxx_flags, "-o", "EchoServer"

    port = free_port
    fork { exec testpath"EchoServer", "-port", port.to_s }
    sleep 10

    require "pty"
    output = ""
    PTY.spawn(testpath"EchoClient", "-port", port.to_s) do |r, w, pid|
      w.write "Hello from Homebrew!\nAnother test line.\n"
      sleep 20
      Process.kill "TERM", pid
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNULinux raises EIO when read is done on closed pty
      end
    end
    assert_match("Hello from Homebrew!", output)
    assert_match("Another test line.", output)
  end
end