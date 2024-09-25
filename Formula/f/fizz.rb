class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https:github.comfacebookincubatorfizz"
  url "https:github.comfacebookincubatorfizzreleasesdownloadv2024.09.23.00fizz-v2024.09.23.00.tar.gz"
  sha256 "becb7ba4a31f18afe1f92d0effabcc22edd41e82a83d8710e02ea3a12f2c8b95"
  license "BSD-3-Clause"
  head "https:github.comfacebookincubatorfizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b4aacbc606834d1e43ec0542127290317b94c56039baaa2be3398617f8eaad18"
    sha256 cellar: :any,                 arm64_sonoma:  "e8d2d4e24de5a1f638f851030ff77a5c5575adc92352b0e60689ff53b495db1e"
    sha256 cellar: :any,                 arm64_ventura: "d233b44733885d782218b4c6994e442cf5eb3ed6ed36c794cf1eba378ac5ae5a"
    sha256 cellar: :any,                 sonoma:        "c2e9ddc1a653bf24d6f12517b4414f3d7b3df30728b23d4bfb0f28ad1ae00893"
    sha256 cellar: :any,                 ventura:       "44d6a31084c32ebde12504bfd8019d4a5c3e8fd9b6443a54e32ddd8fba23b489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc4da05a32df0704a3e6666277019475ae2d84ab4f4640f23c75ab5fb83786ad"
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