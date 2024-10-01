class Wangle < Formula
  desc "Modular, composable clientserver abstractions framework"
  homepage "https:github.comfacebookwangle"
  url "https:github.comfacebookwanglearchiverefstagsv2024.09.30.00.tar.gz"
  sha256 "8af241d7100e974c94cafddf760370d8961e4eea9907863a6343f617bd398182"
  license "Apache-2.0"
  head "https:github.comfacebookwangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "48a3f5d1acee4b9221526f2a41a708dc3b85b39b20857505cd820aeebdf28037"
    sha256 cellar: :any,                 arm64_sonoma:  "c5e8db5a9526271f8bc86dc178fb23ee2db0ba79155ce13ef689eea33ee3204c"
    sha256 cellar: :any,                 arm64_ventura: "a34092ca75a734430c4735c6b708afd5ddbe9794b25525d765e46daadc90a596"
    sha256 cellar: :any,                 sonoma:        "1f70f930400aebb4a02f5247b24aad6350b9d5e5b2ef631fec861cf8867921ef"
    sha256 cellar: :any,                 ventura:       "ec5d49ca9d6361339276fd503a122ddb5b6a7d5de3cbcb71944a50fa58c2eec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8873f4ed99e1b0b7bf145bc0088fd6dce4ae02d1846fa82f702fee585bb5d42"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "zstd"
  uses_from_macos "bzip2"

  fails_with gcc: "5"

  def install
    args = ["-DBUILD_TESTS=OFF"]
    # Prevent indirect linkage with boost, libsodium, snappy and xz
    linker_flags = %w[-dead_strip_dylibs]
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,#{linker_flags.join(",")}" if OS.mac?

    system "cmake", "-S", "wangle", "-B", "buildshared", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "buildshared"
    system "cmake", "--install", "buildshared"

    system "cmake", "-S", "wangle", "-B", "buildstatic", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "buildstatic"
    lib.install "buildstaticliblibwangle.a"

    pkgshare.install Dir["wangleexampleecho*.cpp"]
  end

  test do
    # libsodium has no CMake file but fizz runs `find_dependency(Sodium)` so fetch a copy from mvfst
    resource "FindSodium.cmake" do
      url "https:raw.githubusercontent.comfacebookmvfstv2024.09.02.00cmakeFindSodium.cmake"
      sha256 "39710ab4525cf7538a66163232dd828af121672da820e1c4809ee704011f4224"
    end
    (testpath"cmake").install resource("FindSodium.cmake")

    (testpath"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(Echo LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)

      find_package(gflags REQUIRED)
      find_package(folly CONFIG REQUIRED)
      find_package(fizz CONFIG REQUIRED)
      find_package(wangle CONFIG REQUIRED)

      add_executable(EchoClient #{pkgshare}EchoClient.cpp)
      target_link_libraries(EchoClient wangle::wangle)
      add_executable(EchoServer #{pkgshare}EchoServer.cpp)
      target_link_libraries(EchoServer wangle::wangle)
    EOS

    ENV.delete "CPATH"
    system "cmake", ".", "-DCMAKE_MODULE_PATH=#{testpath}cmake", "-Wno-dev"
    system "cmake", "--build", "."

    port = free_port
    fork { exec testpath"EchoServer", "-port", port.to_s }
    sleep 10

    require "pty"
    output = ""
    PTY.spawn(testpath"EchoClient", "-port", port.to_s) do |r, w, pid|
      w.write "Hello from Homebrew!\nAnother test line.\n"
      sleep 20
      Process.kill "TERM", pid
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNULinux raises EIO when read is done on closed pty
      end
    end
    assert_match("Hello from Homebrew!", output)
    assert_match("Another test line.", output)
  end
end