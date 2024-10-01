class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https:github.comfacebookmvfst"
  url "https:github.comfacebookmvfstarchiverefstagsv2024.09.30.00.tar.gz"
  sha256 "3ee54db3110f26a7f979e016ecb44159fd5ca3992b169b9d31147952d041ef79"
  license "MIT"
  head "https:github.comfacebookmvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9ac217b5535dc9e7d43b5ff20b68eabb475181ff16a23b423ac9812ce3f8421a"
    sha256 cellar: :any,                 arm64_sonoma:  "be451b265857a55d304a8454f93d119930dd4a32631cba2fda170ad2301dd9bd"
    sha256 cellar: :any,                 arm64_ventura: "288b4479fc1679f25d68b727a75d22553cc74c9e48ae8f5c40fb242e95a17b40"
    sha256 cellar: :any,                 sonoma:        "3c98034d92a56668b55a83ebdc8c2e8bd8b1caade9ef8fcdae11bf5269318d08"
    sha256 cellar: :any,                 ventura:       "ab2f38f05c9c06762ea4a5e8078091cb66bb53d6575460b56fa7328851ebb104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e9f4a4734a434378415cb409a199dcd2f3fa2e01f060c032b69ddd2946c83e9"
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

    (testpath"CMakeLists.txt").atomic_write <<~CMAKE
      cmake_minimum_required(VERSION 3.20)
      project(echo CXX)
      set(CMAKE_CXX_STANDARD 17)

      list(PREPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}cmake")
      find_package(fizz REQUIRED)
      find_package(gflags REQUIRED)
      find_package(GTest REQUIRED)
      find_package(mvfst REQUIRED)

      add_executable(echo
        quicsamplesechomain.cpp
        quiccommontestTestUtils.cpp
        quiccommontestTestPacketBuilders.cpp
      )
      target_link_libraries(echo ${mvfst_LIBRARIES} fizz::fizz_test_support GTest::gmock)
      target_include_directories(echo PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
    CMAKE

    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", "."

    server_port = free_port
    server_pid = spawn ".echo", "--mode", "server",
                                 "--host", "127.0.0.1", "--port", server_port.to_s
    sleep 5

    Open3.popen3(
      ".echo", "--mode", "client",
                "--host", "127.0.0.1", "--port", server_port.to_s
    ) do |stdin, _, stderr|
      stdin.write "Hello world!\n"
      Timeout.timeout(15) do
        stderr.each do |line|
          break if line.include? "Client received data=echo Hello world!"
        end
      end
      stdin.close
    end
  ensure
    Process.kill "TERM", server_pid
  end
end