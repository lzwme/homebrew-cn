class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebook/mvfst"
  url "https://ghfast.top/https://github.com/facebook/mvfst/archive/refs/tags/v2025.07.28.00.tar.gz"
  sha256 "2170aba0615cc6c907d0b25fa8afe4f49d3b96cf1cf2bd32c5faeffb65e35afd"
  license "MIT"
  head "https://github.com/facebook/mvfst.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "f040eca398217b759329ce99af1ab05f7c07a025f5baf8d8e0a295b9ed51e094"
    sha256                               arm64_sonoma:  "0fb70a54efbd2371878278d96d382340b3d3233a0af07756aa4cf7f23e6bbdee"
    sha256                               arm64_ventura: "0b5bd93204d192f3f49d863d9e12a6c9c2baec7469cb75af93210949056aed7c"
    sha256 cellar: :any,                 sonoma:        "dac8593f7b918c9dd7cad74e5690ff43d50a053db82525e9897c189d6ff20115"
    sha256 cellar: :any,                 ventura:       "08e6c48c7dd9aa4b217d69b8569e3d23b174964aaf688d63740e5b328642cd44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84fe1a3361937c8a2009de59ea700ca54a755b45ef187df36a44c88dc200e55a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "097ac2a073e7e5c2b5875c745e53d922af3f61b93cdcae76e3539e38a5780ab9"
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