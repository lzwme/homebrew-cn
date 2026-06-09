class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghfast.top/https://github.com/facebook/wangle/archive/refs/tags/v2026.06.08.00.tar.gz"
  sha256 "728c1b406fa62bce8b5bcf607ed9334298e9c3eb3b65e26903e1c404a73772fb"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2b160eb8dbb6ecf1574044fb3e4e111b2b6deccf71cd89736ed7b0ad1879fd35"
    sha256 cellar: :any, arm64_sequoia: "89ddebae3442e6e01ca915dc71df1d2e79521b8dcfea055d420e7890b24c591f"
    sha256 cellar: :any, arm64_sonoma:  "c36225f4fe5dd5d15d8da15c98093d1be1d6f1664bb8754e329a71b212280ea4"
    sha256 cellar: :any, sonoma:        "4e290d40ae23633d24709a9485b1ec8cdb7108f105434092405794bdc4bca1a2"
    sha256 cellar: :any, arm64_linux:   "cfafa55670b459573761d15bebc733b7568d2aeb998de400b1c246f36d51da69"
    sha256 cellar: :any, x86_64_linux:  "e30e87417fa0bf3158205083436523baf83e6c0e221fc9a642836441a8bc86a6"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "libevent" => :build
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  def install
    args = ["-DBUILD_TESTS=OFF"]
    # Prevent indirect linkage with boost, libsodium, snappy and xz
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

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
      cmake_minimum_required(VERSION 4.0)
      project(Echo LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 20)

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
    spawn testpath/"build/EchoServer", "-port", port.to_s
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