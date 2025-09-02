class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebook/mvfst"
  url "https://ghfast.top/https://github.com/facebook/mvfst/archive/refs/tags/v2025.09.01.00.tar.gz"
  sha256 "df7add37679edf553a46d841a368eaf2bae2b76b8af828ccba18b8c26c070a32"
  license "MIT"
  head "https://github.com/facebook/mvfst.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "b38dd5309cebd629914fe210bc67468338569dd98585fc1c697778b052f95bcd"
    sha256                               arm64_sonoma:  "1c6b72b365f997071633a0aa457fe6694cf8ee4f3919db9b66103c1d5294c553"
    sha256                               arm64_ventura: "0f5f5479fd0d4cc978cb6c4a80cd80acca61e92197a1734b405c58e0f0a14ac0"
    sha256 cellar: :any,                 sonoma:        "4956ace5ffa6cd8317a84a669e0cbe735edd2dcac8e44a6ea0df188692f8660d"
    sha256 cellar: :any,                 ventura:       "76361b06517f1f8a1592277b353e410d3f201b6a5121fc88c8743a8a00f1feee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bdd37c273eb702c6529cb28c491aadd4e4995dec77f11c73823d2c2a53fd4ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed1015e8d997a678a3c9242ac71f4119e8318cafc5b30e5982dbd1a33ba237f9"
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