class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebook/mvfst"
  # TODO: add back to `synced_versions_formula.json` when possible.
  url "https://ghfast.top/https://github.com/facebook/mvfst/archive/refs/tags/v2025.07.14.00.tar.gz"
  sha256 "47c4e37da80dda05b1ef59cf65fd9963c6479c724283f3b629bb05d0cd6c4edc"
  license "MIT"
  head "https://github.com/facebook/mvfst.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "5dc40338405c08787c7642874fccbf0e19ed6c37a9871751695c7820ec4623b9"
    sha256                               arm64_sonoma:  "fffbd78d8133bed990ebcd654e6f1e9e4528ada4dd90bcd068f9e78ae2800b19"
    sha256                               arm64_ventura: "91a6a9e01a17a8a59ad032c38a6ce833da99f3cc7a966642b26f58a775bc94c8"
    sha256 cellar: :any,                 sonoma:        "a25507c8f6a4b17a936f3ea0a5291906704980a2ccdd32716601dc483e1df9e4"
    sha256 cellar: :any,                 ventura:       "34739914ecc1f73e925fcfe50acb45d7397222b00f111f45529836de986a9d7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d73589d6dcb7bbfeef72fe982de61253ddeb49661afff8f0549d374393e0889f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9e1108e1ef90ff99e7a9debfef5991071e312547ae3a4d3509514ac3ab8df88"
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