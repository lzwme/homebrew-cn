class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebook/mvfst"
  url "https://ghfast.top/https://github.com/facebook/mvfst/archive/refs/tags/v2025.08.25.00.tar.gz"
  sha256 "116b6cf9f3dc82210bc840b5a9a560f4de82756cac9899d5ad7eab52f9a257ec"
  license "MIT"
  head "https://github.com/facebook/mvfst.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "fd09e7a8a070aa60e18b92984b744628a62c860ef2541e3847a6c95aee962592"
    sha256                               arm64_sonoma:  "06cc9af6f99321b45b862e89bd0e5937f8d038c78612eb54829dcc2fa8f1248c"
    sha256                               arm64_ventura: "07fae04f0b06fde8714b7063b0ca0a84ff3468b9772e9685ee87ded02d501d8b"
    sha256 cellar: :any,                 sonoma:        "8a9e9622b9694cd0d24ebf4fdace9de6ffcca295ce148484fb8a57542f7c1186"
    sha256 cellar: :any,                 ventura:       "72d410f1d8c261494c974cf117c7ff27f8420c9ed7d6539a93a6c23ca92e2992"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd2d44bfa3b632271ea4846c007565057fac7cd8c3856f6ae67fbd2e91342ec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abe01899644db2b168fe3d13f261cbe058d15384d4987d9b8386aeb0eca2c991"
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

  # Fix build with Boost 1.89.0, pr ref: https://github.com/facebook/mvfst/pull/405
  patch do
    url "https://github.com/facebook/mvfst/commit/77dfed2a86bd2d065b826c667ae7a26e642a61d9.patch?full_index=1"
    sha256 "182e642819242a9afe130480fc7eaee5a7f63927efa700b33c0714339e33735c"
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