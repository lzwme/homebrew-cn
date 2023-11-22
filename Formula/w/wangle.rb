class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghproxy.com/https://github.com/facebook/wangle/releases/download/v2023.11.20.00/wangle-v2023.11.20.00.tar.gz"
  sha256 "3017f08a81d11dec2eb4e4bb7a67cb960ed0aafd6f175bc26a80de55073aef1d"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7563234a9b8e7a6b0b4320970d9ccc95167e1b64f915ebd1da6a903797632ee5"
    sha256 cellar: :any,                 arm64_ventura:  "27c1389f9cbafe27184245b4480ea4d890dddf82ad851b172eafedd6126d11bd"
    sha256 cellar: :any,                 arm64_monterey: "ee1b5d00d6223a52c2539d7b0f03421d6a71c913eec9525c4e809a0eef61a1b6"
    sha256 cellar: :any,                 sonoma:         "bc408af6967dd8fd6224e622e310dd74cabd076329fc515cad57002ee4ae74cb"
    sha256 cellar: :any,                 ventura:        "1481e99900e7e64f7ef8284d23fae49bfbc55177a716469d9a6bc2218d91a544"
    sha256 cellar: :any,                 monterey:       "79a0e42b607370b8a904ed05e544d0ffee26c48d57f639681c1e272f4d71b21b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a142fdeff6bbe69f7409889ec33b25f6944afc0bbf374dfe875f4cb1d73085a6"
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