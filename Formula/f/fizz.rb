class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https:github.comfacebookincubatorfizz"
  url "https:github.comfacebookincubatorfizzreleasesdownloadv2024.09.02.00fizz-v2024.09.02.00.tar.gz"
  sha256 "5e1d6ab79019140fed61855dc9863fbd6329e27d0b67b8333d7b999474949082"
  license "BSD-3-Clause"
  head "https:github.comfacebookincubatorfizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "282f24b1fd1213543fbec067e6aed46fe15fe8f244b4df7db5f77049b6d997ea"
    sha256 cellar: :any,                 arm64_ventura:  "9f3f7c1cd45949670b93c2514fa3de1cb2fb188f055b0903ee3ae4ea460f12b5"
    sha256 cellar: :any,                 arm64_monterey: "abcf88e634c07a5b6294f0c1a86e8c5dfe257624d733bf685c6e3577995acf06"
    sha256 cellar: :any,                 sonoma:         "21760dde28985a2e223889fea7178ab4d47d2c42a87034c1d9fbb0049c64d7b2"
    sha256 cellar: :any,                 ventura:        "04509d6a8a5b216952de88319518e252471fc9249afeff2c2dd98955755169d0"
    sha256 cellar: :any,                 monterey:       "f8b155a182c25ac04960a09b4cd0a11a30477cfc39923da58ed7e1a8dda934a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55d558b62b938172689f318326438acad5c0102c0543db09c87934d40e10d19b"
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