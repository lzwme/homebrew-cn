class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghproxy.com/https://github.com/facebook/wangle/releases/download/v2023.05.01.00/wangle-v2023.05.01.00.tar.gz"
  sha256 "033b878af62420bf747b378b98fbe18025512b2a786514cd572b65b9211be960"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a67e6a064c1530f98474c1a3ac0a6f4438bed11c311ed82827ed92f5395c00d2"
    sha256 cellar: :any,                 arm64_monterey: "a9e1d9e700d9450e39bd918f171c47fc7c72510418a7a6359502af329db325d2"
    sha256 cellar: :any,                 arm64_big_sur:  "4d085bb7c872898ea144098c8b2fed66c9e04b8eb1b03eac6f0574cb823d0974"
    sha256 cellar: :any,                 ventura:        "5b0969c6f8f8a0a78163fb271a6bcb4859ad4db1aa401dce937221e3b40bf05f"
    sha256 cellar: :any,                 monterey:       "5f0585f72037b4515334b043d494db219e1beaef5fb93d7b491fe675dcafae92"
    sha256 cellar: :any,                 big_sur:        "bf31de0c022691c70b522902f25fba0e50a0c1cfd95009618f477290035dc15b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46012cf2fd93dd7642e6810ae578071556ae4bb3c87157abdc1da4a6eeacb7e7"
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