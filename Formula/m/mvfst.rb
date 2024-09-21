class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https:github.comfacebookmvfst"
  url "https:github.comfacebookmvfstarchiverefstagsv2024.09.16.00.tar.gz"
  sha256 "fcf34a0bfc130c0836aff8532c05f9423911c179025b96ccea39f7b2cf902aab"
  license "MIT"
  head "https:github.comfacebookmvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f4dfad7e2ca2af52d14bb5fd8b8d8c796da478a32c8fdd3a04fbd120f41935db"
    sha256 cellar: :any,                 arm64_sonoma:  "e5497d67934046b5ff320ee98b1b5e22504d95fc2d69e35b6909ccc470e1b413"
    sha256 cellar: :any,                 arm64_ventura: "48916acfc32560e771ed1ade1fe851c6e6be226bbf40189cbe4cb320d7c5096f"
    sha256 cellar: :any,                 sonoma:        "f643cc3fbfa6c228a9589ff6d33c346739ef2c66e1816b2d09787688e2989f47"
    sha256 cellar: :any,                 ventura:       "c58b409e3daad3f36666a7ae51ae2980858f4e286b14fd3c1feb31726cb17c63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a24399a3da2f38e2f1a4ef328611f49b92415c349931f97439947fc997aa26d2"
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