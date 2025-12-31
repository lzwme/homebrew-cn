class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebook/mvfst"
  url "https://ghfast.top/https://github.com/facebook/mvfst/archive/refs/tags/v2025.12.29.00.tar.gz"
  sha256 "a8b8863a0a80855b60d9b688e8412950e56861d4e2e993b922b9f174f4e05e90"
  license "MIT"
  head "https://github.com/facebook/mvfst.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "d26c4363c9e9070b8630c9a98498f0a0d889fb7f8b2f9f3f625ae7b5e40ffe13"
    sha256                               arm64_sequoia: "878aac84a5a2454ea14f760728dbe10a933535d9123af6b118bf500de43a4700"
    sha256                               arm64_sonoma:  "c74e24847c8478cd8bfc1ef7d4fdf9b5df5572d9d69365ea1f741afd98ec0e0f"
    sha256 cellar: :any,                 sonoma:        "de5dd759f7c1dc4563b8c6058932b4f988a7558531bab38bc6d422df21eb3560"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b47ed0aafa773583ba1b388edf2cc1d4c3435a71009aa83d0a61485825de624d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af4c15da1129b8e15f3f7a5cafe5ffe8e8fed684c73e0aa331a66267131fd7e3"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "googletest" => :test
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "openssl@3"

  def install
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    linker_flags = %w[-undefined dynamic_lookup -dead_strip_dylibs]
    linker_flags << "-ld_classic" if OS.mac? && MacOS.version == :ventura
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,#{linker_flags.join(",")}" if OS.mac?

    system "cmake", "-S", ".", "-B", "_build", "-DBUILD_TESTS=OFF", *shared_args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    ENV.delete "CPATH"
    stable.stage testpath

    (testpath/"CMakeLists.txt").atomic_write <<~CMAKE
      cmake_minimum_required(VERSION 3.20)
      project(echo CXX)
      set(CMAKE_CXX_STANDARD 17)

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
      target_link_libraries(echo ${mvfst_LIBRARIES} fizz::fizz_test_support GTest::gmock)
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