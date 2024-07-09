class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https:github.comfacebookmvfst"
  url "https:github.comfacebookmvfstarchiverefstagsv2024.07.01.00.tar.gz"
  sha256 "833fc3421cb8a17ab1c2b5542e76074bcb9cfd534ec5e459393dd1e774921907"
  license "MIT"
  head "https:github.comfacebookmvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "461e892097635a2df893ceff70431b1c9b460cc845e8903cf2ed0d636026634d"
    sha256 cellar: :any,                 arm64_ventura:  "9c285e6952552d60dfffea700dacdb360e8d023446569479fa4afb9941d1ec52"
    sha256 cellar: :any,                 arm64_monterey: "eae63a564be383a599fd81ee8933745859a9a32c46b5958ea973889e77ac361c"
    sha256 cellar: :any,                 sonoma:         "923b5187b489d80f4977bde471b6c17f7aedf8b2b8e6f3f70f89556ebc9e7386"
    sha256 cellar: :any,                 ventura:        "28e45c6cd97a3c068d95ccccb2b98ce814b43c2115916a7d95e359ab6bae95e7"
    sha256 cellar: :any,                 monterey:       "e8fddb49df64f0b68e76a4facee097f24d012630339e58d5b46780ab9f4739f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56a5ff1199602261ac6b92cbd03bef16b18dfeeff64d63085ecec2d02808a0d3"
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