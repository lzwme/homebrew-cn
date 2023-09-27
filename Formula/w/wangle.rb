class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghproxy.com/https://github.com/facebook/wangle/releases/download/v2023.09.25.00/wangle-v2023.09.25.00.tar.gz"
  sha256 "0e493c03572bb27fe9ca03a9da5023e52fde99c95abdcaa919bb6190e7e69532"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "720f31414dee6cb76ed5f52be71e3df9005cb37cd1de584d91a4e3683fd35c07"
    sha256 cellar: :any,                 arm64_ventura:  "e7818613cbdead08926375c904e8675eea1c3dbd72746885d9becdedb6e51dcf"
    sha256 cellar: :any,                 arm64_monterey: "5e4cbcf3cff1b5210655cb9bf06e53234a6aa7a522b458ec1c4f3119267aad1c"
    sha256 cellar: :any,                 sonoma:         "f3b6451ecebc03b9aaf30b779b7b8d0ab5005ae295df6bb544f72e6a1b4a6c30"
    sha256 cellar: :any,                 ventura:        "e5754c9fbec95073615a83f7ea25499e390d19dd3d19121cb8d0ed7856bd7579"
    sha256 cellar: :any,                 monterey:       "60c3f7184e99873a20d3793de98fc60986ffebf1406959b808610b0495a6e428"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "063e09906aef5ab7dcf33168c6f7e773bfa8ec930461b17d76dfbf30e058e503"
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