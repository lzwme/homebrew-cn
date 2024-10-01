class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https:github.comfacebookincubatorfizz"
  url "https:github.comfacebookincubatorfizzreleasesdownloadv2024.09.30.00fizz-v2024.09.30.00.tar.gz"
  sha256 "988f737b7eb3cc41ad3cce9a20c3b470fbb6e89ee1a4cc9c3bef5c4bde9218b3"
  license "BSD-3-Clause"
  head "https:github.comfacebookincubatorfizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d4d798ebae86b71d2d9838c0349d99824b52f4131d32c4f892cf50a8bca6498e"
    sha256 cellar: :any,                 arm64_sonoma:  "3dab60b1e4658738cbd086498d891626954ad53dc270c91d0ad71419fa3c25c7"
    sha256 cellar: :any,                 arm64_ventura: "324e427464b61de9f9666ee4880563611ce4c4ea0c4726499e57b0f582b6bb26"
    sha256 cellar: :any,                 sonoma:        "bc92be07ced8f12b8b99f2f954c32ec0d1a3887227085010d6cb7748ac13796f"
    sha256 cellar: :any,                 ventura:       "ce9d3280fc96c3cf849c3148d8face1f6c6fd92df08529c6cb46ffef2ab4eebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5455608af21ce4805ee13a921bd29764a07ee4e9945c5078f37e33be52f6bebf"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "libevent" => :build
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "zstd"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    args = ["-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    if OS.mac?
      # Prevent indirect linkage with boost and snappy.
      args += [
        "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
        "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
      ]
    end
    system "cmake", "-S", "fizz", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # `libsodium` does not install a CMake package configuration file. There
    # is a find module (at least in 1.0.20 tarball), but upstream has deleted
    # it in HEAD. Also, find modules are usually not shipped by upstream[^1].
    #
    # Since fizz-config.cmake requires FindSodium.cmake[^2], we save a copy in
    # libexec that can be used internally for testing `fizz` and dependents.
    #
    # [^1]: https:cmake.orgcmakehelplatestmanualcmake-packages.7.html#find-module-packages
    # [^2]: https:github.comfacebookincubatorfizzissues141
    (libexec"cmake").install "buildfbcode_builderCMakeFindSodium.cmake"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <fizzclientAsyncFizzClient.h>
      #include <iostream>

      int main() {
        auto context = fizz::client::FizzClientContext();
        std::cout << toString(context.getSupportedVersions()[0]) << std::endl;
      }
    EOS

    (testpath"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(test LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)

      list(APPEND CMAKE_MODULE_PATH "#{libexec}cmake")
      find_package(gflags REQUIRED)
      find_package(fizz CONFIG REQUIRED)

      add_executable(test test.cpp)
      target_link_libraries(test fizz::fizz)
    EOS

    ENV.delete "CPATH"
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", "."
    assert_match "TLS", shell_output(".test")
  end
end