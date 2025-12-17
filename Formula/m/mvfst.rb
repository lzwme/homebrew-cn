class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebook/mvfst"
  url "https://ghfast.top/https://github.com/facebook/mvfst/archive/refs/tags/v2025.12.15.00.tar.gz"
  sha256 "acbb76ffdf9a2c38fff0a80efbb04422c2c7ba4934bdc0630626d8bb2db9f144"
  license "MIT"
  head "https://github.com/facebook/mvfst.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "c410c628fd0ad0f7116a670358f505588c785c37d98041f1f57fe0bbb31fcc7d"
    sha256                               arm64_sequoia: "4026f0143aa9db77a828e861524e33c12c1938919c0b935232ae11295efd65eb"
    sha256                               arm64_sonoma:  "4a002bfa3a4e395ad3d21b20ec87dbcf7904c94cdbee6bafee23cbfee41f9bfb"
    sha256 cellar: :any,                 sonoma:        "a24a5fe4db8fe2c853f8cd2a77009e4e1495c77c4b868bfbd28a23d842d835d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a00a81254cdcebe9d228f706f0b90ea1819c1f67478a4bcd330b78228a67a73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc14e5e003b7efd7668541aa0f84817fb806af0ea23f72a0b0520ff64d1d36da"
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

  # Fix CMake config
  # https://github.com/facebook/mvfst/pull/416
  patch do
    url "https://github.com/facebook/mvfst/commit/a65e4d4042dd6a37448550bb7de42cc591a917e9.patch?full_index=1"
    sha256 "a6d7602b0372ea791664948a1ecdb006479c352b402174f42596384ee9b6c864"
  end

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