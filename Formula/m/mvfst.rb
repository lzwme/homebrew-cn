class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https:github.comfacebookmvfst"
  url "https:github.comfacebookmvfstarchiverefstagsv2024.08.05.00.tar.gz"
  sha256 "381bbe1617a72ca484b1ece814ae89264792b0204134312db3227b5176dec651"
  license "MIT"
  head "https:github.comfacebookmvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c0d0aba448acbeb653434844343cce7111af0aa65a6065b7e7d89324e7ffd0c7"
    sha256 cellar: :any,                 arm64_ventura:  "41f924ad21a4dd6b37eff217635241e766195bdd15ded4027641c0b6a301f01f"
    sha256 cellar: :any,                 arm64_monterey: "ce65392959b8d033e7dba9878d23f4914bf87d255a003ad210bc1c560c22fc0f"
    sha256 cellar: :any,                 sonoma:         "dca7985fb6dbaf440bdb010202f228be448911b6ebc476dbb554efaf4f6fca6e"
    sha256 cellar: :any,                 ventura:        "b14f9f8f091ef8ccaa95e1308d97130bc71a3285e4fb4bceb293f759123d12ca"
    sha256 cellar: :any,                 monterey:       "591b658b2e62a0b1d9db90799ccd69f5c8fec81e527e96c0a296d7010c78c6f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a8c6574a230eb5a8ce21fe207047ce55b7d39a5bb3b910025030c144b23dd5e"
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