class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https:github.comfacebookmvfst"
  url "https:github.comfacebookmvfstarchiverefstagsv2024.09.09.00.tar.gz"
  sha256 "31dd28c03e0674897ed757116195eaedf56ecf5f6165c57c6d3ea0b4a5ea7233"
  license "MIT"
  head "https:github.comfacebookmvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ea98e68d6475ab1d555eef6bc4079fde1cd793e63aeca829452debf751b10ee7"
    sha256 cellar: :any,                 arm64_sonoma:   "17a71f1a54a54775a03e478fda06a66b71163616fbecf938ef1cab60f2f89723"
    sha256 cellar: :any,                 arm64_ventura:  "f10067b568c23154c063b5b38449b708d6329e7b887758e2bdf68a80a36b2f01"
    sha256 cellar: :any,                 arm64_monterey: "a974f301ec1e660b2c696996918c4012b81af8eb3654db05a9f8cf296b7bed83"
    sha256 cellar: :any,                 sonoma:         "53f331720097e3e4bd12d2157094bee5e41ca028b2d758d3a5c9224b111023f2"
    sha256 cellar: :any,                 ventura:        "ed7f89b1929bdf645ae55a557e6f24a9daced29eaef071f787dd8dddef7db4c9"
    sha256 cellar: :any,                 monterey:       "dd1cfd8a0cd4094002b65507c52749eb3b1949cf3f010f07a6b9cd2a5befc99a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f50441ac22210f27de3dc10efe0128ff53a3a2bed829deddcf2c5e3602f2d079"
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