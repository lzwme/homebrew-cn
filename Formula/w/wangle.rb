class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghfast.top/https://github.com/facebook/wangle/archive/refs/tags/v2025.09.08.00.tar.gz"
  sha256 "4195b67d75ca052d038e37c513e6ebbe034b3c61108ec9b81e72c3cb340d2cf3"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6bf466c1ac6014c20e06a1791726e67145f7390b679655891442a21e5c5f8820"
    sha256 cellar: :any,                 arm64_sonoma:  "abfb27c28dd0b88fe12a7a2263c7508cf3ffdc5de637c650ef4a72a0fe6ef26d"
    sha256 cellar: :any,                 arm64_ventura: "251031a583b305e55f70e18c4a19af5d13d6e75dab4f7a2e80ab4a1efe08f91b"
    sha256 cellar: :any,                 sonoma:        "c3c51e9b37005170cd38841b2dabf1ad224a53f44658595f2b6c2d7b21e6f4d3"
    sha256 cellar: :any,                 ventura:       "c11a2a91eb78c94ccfbc19b64ef3694d2c347b11c8e14a6d42c67ebbf41a81dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9d640ec992c21b5d8e521fb93ce6404dd28e60b913670b5b495964ef6dd2175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c26f9a742e8aa3f701db7ab64692130b235321a88ea3bd071660afba7f7d20a8"
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