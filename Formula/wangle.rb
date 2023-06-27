class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghproxy.com/https://github.com/facebook/wangle/releases/download/v2023.06.12.00/wangle-v2023.06.12.00.tar.gz"
  sha256 "ad9225e810967f023af93376cc8484f66c0a7a0a9687f47e07a1ea7bef2662a1"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f94387de717450135dd64190147dcfbaecd54ca6f9e090b361f022c7c21a78fd"
    sha256 cellar: :any,                 arm64_monterey: "b544a5374a81aa769f65c067ae389629439b86dfcbf7c3584510daf935e4ca19"
    sha256 cellar: :any,                 arm64_big_sur:  "bd90cb94117dc21a6978ee1f6a475bf64f63bf48e2bd0af038d5e55194894f51"
    sha256 cellar: :any,                 ventura:        "bc6626d73c7993421de567ce7343b0e900a34f680041a4725dbf00bcc831ae99"
    sha256 cellar: :any,                 monterey:       "78e6dd27ce66c8a574407f47cc2bf55ff4b3179af1328978eab6b7cb88fba090"
    sha256 cellar: :any,                 big_sur:        "02f976c651403c55fd290ac623869f2e9b22463ff0d38c6c73cba45b11aa8054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af4d2f93e6ead3b2256187a3231c7ca14dbc3b0e72b9c59de33caf5864fe0b50"
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