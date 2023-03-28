class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghproxy.com/https://github.com/facebook/wangle/releases/download/v2023.03.27.00/wangle-v2023.03.27.00.tar.gz"
  sha256 "88c2354c82deb29203b1cb48c1e69b32ea97ac93aa6c5e4bc8b9483a108031f9"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1e8b8029caec24775dfacfbc40eabd025433e217a30b8c348d73aef4e608d1f8"
    sha256 cellar: :any,                 arm64_monterey: "90dbbd744d809f31c3c70e0375df41ebbb35edf3811dea7f44510fb0034f59d7"
    sha256 cellar: :any,                 arm64_big_sur:  "eb8697444cb799b175d8b9d3d34d608d6c24b08c9d0a4d3bb31e4b3c35a9a323"
    sha256 cellar: :any,                 ventura:        "b560eebd2fef2512068ae69227587d651b5974fca2b319a05a66908f065f71c3"
    sha256 cellar: :any,                 monterey:       "ccc0e1176e7520a4446d7ba58fcb07f98071a3430795745e43b33590a3fe7193"
    sha256 cellar: :any,                 big_sur:        "a3f16a067a814b1b237aa44283ead83dd73e6345f6e3b340eac999170b8d3c61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08d3713a7ea7c3168df599c663efd7de0aede11427744d45a53b288ade59cdd0"
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