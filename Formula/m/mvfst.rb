class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebook/mvfst"
  url "https://ghfast.top/https://github.com/facebook/mvfst/archive/refs/tags/v2026.04.27.00.tar.gz"
  sha256 "1ba2702e4e66a3e61eabd05fd2a8ec0fa39517a17c5a1390951f3af74adb829c"
  license "MIT"
  compatibility_version 1
  head "https://github.com/facebook/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "74987a53fd9e8be31c3b8bf96a2960c95023edb45f62d4dce4f5bd13d47dd7b9"
    sha256 cellar: :any,                 arm64_sequoia: "d2ef3f983e25f980468229505bae81e2777512d54949943ba68260b6c4d54bdf"
    sha256 cellar: :any,                 arm64_sonoma:  "efc0b3f7832f1a8d47b6392d8a5b024ebbafc1995bb43044f1da353380359fe2"
    sha256 cellar: :any,                 sonoma:        "b6f6887ad9252470e46d1c6d81b8c31a06c50e36c5b474cf2b9d7dc91f3c9881"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "407317742a836d24c68144c24799f94375af7f9c3dadfe75488b83ee3537f4d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2cfee6a93f72f6de5353f4b506ba6f4b1abc0d5488285062c6af5f985652d92"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "googletest" => :test
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  def install
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup -Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "_build", "-DBUILD_TESTS=OFF", *shared_args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    ENV.delete "CPATH"
    stable.stage testpath

    (testpath/"CMakeLists.txt").atomic_write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(echo CXX)
      set(CMAKE_CXX_STANDARD 20)

      list(PREPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
      find_package(fizz REQUIRED)
      find_package(gflags REQUIRED)
      find_package(GTest REQUIRED)
      find_package(mvfst REQUIRED)

      add_executable(echo
        quic/samples/echo/main.cpp
        quic/common/test/TestUtils.cpp
        quic/common/test/TestPacketBuilders.cpp
      )
      target_link_libraries(echo mvfst::mvfst fizz::fizz_test_support GTest::gmock)
      target_include_directories(echo PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
      set_target_properties(echo PROPERTIES BUILD_RPATH "#{lib};#{HOMEBREW_PREFIX}/lib")
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    server_port = free_port
    server_pid = spawn "./build/echo", "--mode", "server",
                                       "--host", "127.0.0.1", "--port", server_port.to_s
    sleep 5

    Open3.popen3(
      "./build/echo", "--mode", "client",
                "--host", "127.0.0.1", "--port", server_port.to_s
    ) do |stdin, _, stderr, w|
      stdin.write "Hello world!\n"
      Timeout.timeout(60) do
        stderr.each do |line|
          break if line.include? "Client received data=echo Hello world!"
        end
      end
      stdin.close
    ensure
      Process.kill "TERM", w.pid
    end
  ensure
    Process.kill "TERM", server_pid
  end
end