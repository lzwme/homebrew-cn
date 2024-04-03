class Wangle < Formula
  desc "Modular, composable clientserver abstractions framework"
  homepage "https:github.comfacebookwangle"
  url "https:github.comfacebookwanglereleasesdownloadv2024.04.01.00wangle-v2024.04.01.00.tar.gz"
  sha256 "d7eee5fc4485ff2d90d50c8165d944c4c330fcab01660d44e8ae91f38f9f8eb2"
  license "Apache-2.0"
  head "https:github.comfacebookwangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "feea922fcbb06b24056d3a57c8b6b54e57b67c109423be0ec12d26ca5bb34373"
    sha256 cellar: :any,                 arm64_ventura:  "9b6f852f0ebfdb8bce2bd6ec46f0c093f32a8ec10856c40d93eb412e93b32f10"
    sha256 cellar: :any,                 arm64_monterey: "c2c35647f64638917d62570300a62953acb52ecf6cb5f7ada74c9c8064f3b044"
    sha256 cellar: :any,                 sonoma:         "caba300ca53976b9f82584702249463d9c8176b0d3709adadc3904d6d4828197"
    sha256 cellar: :any,                 ventura:        "9daa372f2524284f3825e3166691b5b3ea00fb780e84ad5cf2b786c0e93e4033"
    sha256 cellar: :any,                 monterey:       "544ca19d70aa09b7d8b2312677da34add6907753c4a85d836249c1f99abda6dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18fa1d1c52f30e24cf9a919bfe1bf1a60144fabfd70c1bd1bc42240991120ae0"
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