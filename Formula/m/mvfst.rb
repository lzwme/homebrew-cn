class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebook/mvfst"
  url "https://ghfast.top/https://github.com/facebook/mvfst/archive/refs/tags/v2025.11.10.00.tar.gz"
  sha256 "c970a893f4bcfe5658c217e91ffe81ca1283d91340d699cc5496da9f4e96bd75"
  license "MIT"
  revision 1
  head "https://github.com/facebook/mvfst.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "81c21d8fef217352bbea8299b50c1919da18fa7668c4fb59d8f7bf9a94def797"
    sha256                               arm64_sequoia: "e3e43d35b5cf00df0a634e8c56cf02f349963aaaade2a4343dc5708465313886"
    sha256                               arm64_sonoma:  "20925cd34d91e197fd4c76745f0b71003ea368a683cf4ad8d7a4c6b4ac1fed73"
    sha256 cellar: :any,                 sonoma:        "118cd1093341b2308bbb9928a749d44959e676867b9e5b27b7d69f8fe395615c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edd41c8e8f10a0f25b68c730edecb7933c287dea3e183ef5cbeedccddf3fe8b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e5cb09b762b4a827946a196b9c446e37c0c2bdd733dcb5cc3d8fe488b4b74c1"
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