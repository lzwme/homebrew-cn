class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghfast.top/https://github.com/facebook/wangle/archive/refs/tags/v2025.11.10.00.tar.gz"
  sha256 "7cc9bd32619fcb14cc9ac4ced71401f85130514c812c5d6b3b904dc720c4e9a1"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "49f03144cedb4416cfa426d781d1672f14128a3d78492b15df9e6e417b256e1c"
    sha256 cellar: :any,                 arm64_sequoia: "291c1d814418e58a4f2f1abe1492aa166721d87aa72b78a0440ca0c2bf04b055"
    sha256 cellar: :any,                 arm64_sonoma:  "50fc62c3bd043c909dc33b70a042ae37ed32a6f27d6ef0aa41f46894d9a93cd7"
    sha256 cellar: :any,                 sonoma:        "ac06d2b0f1a27b8c2449cf640c605c45a13239c92c4202e95e87e9d4fcf676e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55cd44cbbaf472a5d7f655f6a324d8ed372a86f90dfb1797b92f3f7ed52fb541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a7ffaf24a1067e34cbcd29649031180f3bfee67ee4e3402b50a9679fd62ec2a"
  end

  depends_on "cmake" => [:build, :test]
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

  def install
    args = ["-DBUILD_TESTS=OFF"]
    # Prevent indirect linkage with boost, libsodium, snappy and xz
    linker_flags = %w[-dead_strip_dylibs]
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,#{linker_flags.join(",")}" if OS.mac?

    system "cmake", "-S", "wangle", "-B", "build/shared", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", "wangle", "-B", "build/static", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/lib/libwangle.a"

    pkgshare.install Dir["wangle/example/echo/*.cpp"]
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
      project(Echo LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)

      list(APPEND CMAKE_MODULE_PATH "#{Formula["fizz"].opt_libexec}/cmake")
      find_package(gflags REQUIRED)
      find_package(folly CONFIG REQUIRED)
      find_package(fizz CONFIG REQUIRED)
      find_package(wangle CONFIG REQUIRED)

      add_executable(EchoClient #{pkgshare}/EchoClient.cpp)
      target_link_libraries(EchoClient wangle::wangle)
      add_executable(EchoServer #{pkgshare}/EchoServer.cpp)
      target_link_libraries(EchoServer wangle::wangle)
    CMAKE

    ENV.delete "CPATH"
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_MODULE_PATH=#{testpath}/cmake", "-Wno-dev"
    system "cmake", "--build", "build"

    port = free_port
    fork { exec testpath/"build/EchoServer", "-port", port.to_s }
    sleep 30

    require "pty"
    output = ""
    PTY.spawn(testpath/"build/EchoClient", "-port", port.to_s) do |r, w, pid|
      w.write "Hello from Homebrew!\nAnother test line.\n"
      sleep 60
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