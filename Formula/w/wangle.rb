class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghproxy.com/https://github.com/facebook/wangle/releases/download/v2023.10.30.00/wangle-v2023.10.30.00.tar.gz"
  sha256 "cd46e08eb43dbd7650bc2a40f9617c99127c6fd80d2c243b8e260460869fcb93"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e7752bdb3b74021be188bfa52ed9a8510fd380658559efde38b5da5e19871a3b"
    sha256 cellar: :any,                 arm64_ventura:  "32f562ac41495b88ae47e8fd42be332ea4fc450238f854e0324c74e313d56f71"
    sha256 cellar: :any,                 arm64_monterey: "cd4f69448bf22e98df192b6be67fa6662d77eade4cc81dd05c4a95fab4ca2006"
    sha256 cellar: :any,                 sonoma:         "cd20cd1a7e2bd8554610a7974b9836bf9b0c7ecdebda6379e95a2abbe6edffd2"
    sha256 cellar: :any,                 ventura:        "27c74150f048494abfa3c23ef1ead941a857dad4c60ffd97bdc09f0ff95ab0ce"
    sha256 cellar: :any,                 monterey:       "a6e41919af38358d5f32927b184bbbcef576a5a08a5aa2c43642636b8f42dabc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed5032696b6e04292e47524842c050a87deb3cc73dc09b74854f3827d9786b17"
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