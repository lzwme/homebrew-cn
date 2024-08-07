class Wangle < Formula
  desc "Modular, composable clientserver abstractions framework"
  homepage "https:github.comfacebookwangle"
  url "https:github.comfacebookwanglearchiverefstagsv2024.08.05.00.tar.gz"
  sha256 "7520bcba0d6d39208d8bdc533e5cbc851b59cdb6105decd1cd83b2bd8a3f0d77"
  license "Apache-2.0"
  head "https:github.comfacebookwangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "754e81a5d2e55fd4eb94dc7cccf0f5a47973caf0ec2f6f75bbadd4d695729d57"
    sha256 cellar: :any,                 arm64_ventura:  "d2f50e43520ce7bee7ae7829bb93ea8f13fe7e65c0fdcfa79b6d79079350fd46"
    sha256 cellar: :any,                 arm64_monterey: "2425875b18414e856a6b6678dffa8d15b7fb340788fa7848013f86f0f582d16c"
    sha256 cellar: :any,                 sonoma:         "c6104a038e72b45f8a3ddb2ee9483d5fedf2fc75095e6d50ee8fe807e888f36b"
    sha256 cellar: :any,                 ventura:        "6e7a8f11837f8963684c00d43a65ec88e9139aacff906a8ecf462c9609ad5d59"
    sha256 cellar: :any,                 monterey:       "3c71212b9be293f6ace43e698fedbf1bda33b6b0f165ac8233ab725aadd472c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72cff38454b5c642be4708d0d717011e6793f8bac6ed5115993a0085b17ce116"
  end

  depends_on "cmake" => :build
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "zstd"
  uses_from_macos "bzip2"

  fails_with gcc: "5"

  def install
    args = ["-DBUILD_TESTS=OFF"]
    # Prevent indirect linkage with boost, libsodium, snappy and xz
    linker_flags = %w[-dead_strip_dylibs]
    linker_flags << "-ld_classic" if OS.mac? && MacOS.version == :ventura
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,#{linker_flags.join(",")}" if OS.mac?

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