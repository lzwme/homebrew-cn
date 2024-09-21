class Wangle < Formula
  desc "Modular, composable clientserver abstractions framework"
  homepage "https:github.comfacebookwangle"
  url "https:github.comfacebookwanglearchiverefstagsv2024.09.16.00.tar.gz"
  sha256 "52ff724ef7cc0e5a8ca7c601a9a8fb48d7d524e669055f4c82ea65df65178504"
  license "Apache-2.0"
  head "https:github.comfacebookwangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ad88b14d66c1770ca486a94df2d4f6b46372ff2a4bbafdd9468f191df83d7f14"
    sha256 cellar: :any,                 arm64_sonoma:  "81a45b0c940b06c9032db9f8ec35c74353e6053913d6cff7d5a22ea86d27f583"
    sha256 cellar: :any,                 arm64_ventura: "9709e5703661a43aba5c79d6bcf6ead43c038ac63eacf8bf8ae762b0daa4395d"
    sha256 cellar: :any,                 sonoma:        "afb2287c4cefb2c1bcbda5ce8a92c45054a6804e76f53fb67567b1926d6ebccd"
    sha256 cellar: :any,                 ventura:       "15d7d261dba5482cbc461a914525f502b76a222651f915816616a0868e6cf668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34cfd57718e0e384b6e23781523dbca7175dead27bef5bf076e331925cdf865f"
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