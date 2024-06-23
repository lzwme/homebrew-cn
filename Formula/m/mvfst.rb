class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https:github.comfacebookincubatormvfst"
  url "https:github.comfacebookincubatormvfstarchiverefstagsv2024.06.17.00.tar.gz"
  sha256 "748c744dae967a0ac25c89a6c7ccf62da2a4974ab45644d395fb7bc8f2e96dc1"
  license "MIT"
  head "https:github.comfacebookincubatormvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b12d9bd96d7dc7c8e032aa2513f49e128ed902e2c5bf25c22ea69ee6c4aac1ad"
    sha256 cellar: :any,                 arm64_ventura:  "98aab8e35c6f28cb55f354e2adf37ea3c6298b2d6b2f71e6861842d6680cd36f"
    sha256 cellar: :any,                 arm64_monterey: "747efae3909bef9f2c3d454e9b67c67527332374fa4c57370de2841d7b9b2ef4"
    sha256 cellar: :any,                 sonoma:         "a6293d32a221beb469cf4935c70fa4ea3996e4a9139e1a9a6a7614dd6b1cf43e"
    sha256 cellar: :any,                 ventura:        "a699bbf32480facec8b89be5b2c415e9b6ab85fa47c85400dfb1d5aa274050b7"
    sha256 cellar: :any,                 monterey:       "9b682f3eecdc10d77921f5d87a38dadfd28aa79da4f8f9de4f2c5c84bd1dd878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6a0de751b0df364efbe733bd4e0f0e61b27287d3b1e37e9a121769dc30b61af"
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