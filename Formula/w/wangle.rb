class Wangle < Formula
  desc "Modular, composable clientserver abstractions framework"
  homepage "https:github.comfacebookwangle"
  url "https:github.comfacebookwanglereleasesdownloadv2024.04.22.00wangle-v2024.04.22.00.tar.gz"
  sha256 "8e52b7655d31f028d7eb874fedac5e41a9903412303cd20f809aea1d206b0f97"
  license "Apache-2.0"
  head "https:github.comfacebookwangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d3bcceb905966e14b5f1df163f93498cd4bd6f4446ab35ad248f6ccc98453fa6"
    sha256 cellar: :any,                 arm64_ventura:  "e93b5628aa6c7db2183f7c66a4275335c212bf6c6a3a0c267e1e0ee19395adc4"
    sha256 cellar: :any,                 arm64_monterey: "fbeb8ee91500823f97415bb8ddc86611fe4ae3960fdf8572f8e87e623f311a87"
    sha256 cellar: :any,                 sonoma:         "00a61615a88fe74260cf890e167716b7edc9bfb2ab74efd0d230c53c71c57800"
    sha256 cellar: :any,                 ventura:        "ee96f9780ab09456ef304425ff576a01cef8bc07f3fcb0a561d9258beaa39966"
    sha256 cellar: :any,                 monterey:       "714cafe731fbbec0e85ab388159fd12ca67cd2575c11bae7f8acb9deac8ef098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bbd95fa85f5c44212ee2e3e7a8c42627a21c18e022ed1b621c335df60628fdf"
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