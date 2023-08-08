class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghproxy.com/https://github.com/facebook/wangle/releases/download/v2023.08.07.00/wangle-v2023.08.07.00.tar.gz"
  sha256 "574b8f713b669113519fc678cbb500910aa17960826731d4b624cb6829f3457f"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "57a9a4f5aff80e0f73782a9a9df34f128fb54831b412242c03ad7904fc2e29cc"
    sha256 cellar: :any,                 arm64_monterey: "e2937e3bff412c986baea099baf2cdd7530a82151d2e3afd3daaeef101c3a3b2"
    sha256 cellar: :any,                 arm64_big_sur:  "4491090eb8ef55dd3289652c13b13e334b3b44e472d59a6721a9485a61b11f60"
    sha256 cellar: :any,                 ventura:        "6645f08e253f86520da8dc672bfd2da3de41f89f7057896dcac336244263dab4"
    sha256 cellar: :any,                 monterey:       "dcda358df6160573b7cef0a0737db37a5b121f795fa6c314b9642c1d926ad735"
    sha256 cellar: :any,                 big_sur:        "65e58a62a61bc468542517b951230f052d152c3fe57471dcf8f76fdd3e2c62b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4556b200be94abbcf2928254f4d6d17e0635743e5da98de305d3ee648d85061f"
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