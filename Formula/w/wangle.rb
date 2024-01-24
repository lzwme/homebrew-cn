class Wangle < Formula
  desc "Modular, composable clientserver abstractions framework"
  homepage "https:github.comfacebookwangle"
  url "https:github.comfacebookwanglereleasesdownloadv2024.01.22.00wangle-v2024.01.22.00.tar.gz"
  sha256 "b6b0a43021604bf4cb51aa895ca47e7846f17a36b1419313d7d0c793bb742d0f"
  license "Apache-2.0"
  head "https:github.comfacebookwangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c19301c3ed4089f800aa832f740becb16f7b60192cb44f550f1f250695b32525"
    sha256 cellar: :any,                 arm64_ventura:  "21267143f324ca51c1355eb904da3d85dfe555f031c0b8b98d6551e5a79e76db"
    sha256 cellar: :any,                 arm64_monterey: "2a2af799c8bf8887ba0291379b240dcb67ce1242dd7443b44a13468f25b9bc8f"
    sha256 cellar: :any,                 sonoma:         "0f89f375c6ed4d559669d9fc67be0a2e2c425866a4eea787111f436fd95e3252"
    sha256 cellar: :any,                 ventura:        "58d4ba960f369f361aaa7f157a2ec33b5a0c981fc0b2799ca51dd20a8749e5e5"
    sha256 cellar: :any,                 monterey:       "d6f46bb582401002bc01b2a6d5f6c3f3d1bbb22b357c12d57324120520fac78d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b583c358027f28b40fe24b9d5350247903aa8a093378612162e831cfff3ce28a"
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
      lib.install "liblibwangle.a"

      pkgshare.install Dir["exampleecho*.cpp"]
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