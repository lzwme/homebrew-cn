class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebook/mvfst"
  license "MIT"
  head "https://github.com/facebook/mvfst.git", branch: "main"

  stable do
    url "https://ghfast.top/https://github.com/facebook/mvfst/archive/refs/tags/v2025.12.22.00.tar.gz"
    sha256 "67777456d8460d5f2efc7eb95ccafce55cbe70ce64089763cb0bfeb02c3336af"

    # Add PacerFactory.cpp to the build
    patch do
      url "https://github.com/facebook/mvfst/commit/1832b36f31b892a78a86c9c54101c4b86f6da7b6.patch?full_index=1"
      sha256 "58bcb121f9c778b4cdc849d969602f9251f934beaba5e806443c6572a4abb473"
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "cb6ee52d133042740f85ffed4c1818b281670effd381c5e557be2acea7c8bd4e"
    sha256                               arm64_sequoia: "8097a473c978e25c24e197adc0ad3d7fc5b919c60a6d74af053df1d8132c49ac"
    sha256                               arm64_sonoma:  "e83cd37c38cb16603b35bb74a558337246659344ca014e2ed4d2efc04080df99"
    sha256 cellar: :any,                 sonoma:        "a21f2210a7c1c2402a934c051b36c21def004f04c1814f87774f7d3aa47867c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8545d71e83f7768fdcfa67497a3e0d51aae4c3708efc5cf0b0c6deef73f9543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba757943bca8e6645f3a95be77026e73b47a72dc7fb4cad7164ae177a9e148c4"
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