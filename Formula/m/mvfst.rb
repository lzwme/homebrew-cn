class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebook/mvfst"
  url "https://ghfast.top/https://github.com/facebook/mvfst/archive/refs/tags/v2025.09.08.00.tar.gz"
  sha256 "704101f5045c2a7dff144b38a0a550f9e4d0a37efa9fcb991b5e19a06c223c06"
  license "MIT"
  head "https://github.com/facebook/mvfst.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "5ce5e46abab9968b0bd333f47dd5770c97ec6fc3dcda975db94c7cc231952e39"
    sha256                               arm64_sonoma:  "a161eb274a5fc9f694da9f0a6f39dd490cbc380c37b01c48f951f5bf270b3fa0"
    sha256                               arm64_ventura: "4e58e2fbbfe6e0ae5a0b547af07423b42a96579f99f6d195e0a8d70abd64d70d"
    sha256 cellar: :any,                 sonoma:        "cb6222e3d6f967daf09a82e9168d22f85ccb194e8addf2638c5a501a4e7a4743"
    sha256 cellar: :any,                 ventura:       "620fbf6e4a05e136a35a7f6bf65448e428fe4fec645609ba68277211554302ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edf57919496ea6f1b0837bbc14b8603075ec374bbf87575bc6b6bf8f692c9201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de69c420c983b270dc5707792b3e3d7b6a8c9d1da29155edc6829ebffd57d8d2"
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