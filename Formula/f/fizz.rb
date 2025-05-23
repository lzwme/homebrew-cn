class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https:github.comfacebookincubatorfizz"
  url "https:github.comfacebookincubatorfizzreleasesdownloadv2025.05.19.00fizz-v2025.05.19.00.tar.gz"
  sha256 "f90364c59891a6dc544ab17960b5109b1cc23913dd4b6a78d88bc19381eb89b6"
  license "BSD-3-Clause"
  head "https:github.comfacebookincubatorfizz.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "30af35a01458a53c2b5fbb0cd5f280c1708b25166cffc3b39c4e8337fce0e80a"
    sha256                               arm64_sonoma:  "5d44d8b3e399354d3e2d8fe33a2afde21be958dfcc2dfe09ccd661b41a9a8ce3"
    sha256                               arm64_ventura: "b4370d772b11b97b7c8c8cf4b43e2496bf778ce6a14d6abfd5ce132a64d7e3df"
    sha256 cellar: :any,                 sonoma:        "a33603db7284c021deec9fdc91931e279904e37b41cdb289a94e1915604fe9d8"
    sha256 cellar: :any,                 ventura:       "adc939902d29ae06c607f6f70d619d78b4e73afdf69d8efc23bd26f2e4af1fee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa7540f2de1020f4eeb9dfbcfb9da72454eb95a25e9f9fd08afe1202f0c7d518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d4591aba6c07eb9243eba2894e3f15d307317a60c20346810b2b94d80122e0a"
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
    (testpath"test.cpp").write <<~CPP
      #include <fizzclientAsyncFizzClient.h>
      #include <iostream>

      int main() {
        auto context = fizz::client::FizzClientContext();
        std::cout << toString(context.getSupportedVersions()[0]) << std::endl;
      }
    CPP

    (testpath"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(test LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)

      list(APPEND CMAKE_MODULE_PATH "#{libexec}cmake")
      find_package(gflags REQUIRED)
      find_package(fizz CONFIG REQUIRED)

      add_executable(test test.cpp)
      target_link_libraries(test fizz::fizz)
    CMAKE

    ENV.delete "CPATH"

    args = OS.mac? ? [] : ["-DCMAKE_BUILD_RPATH=#{lib};#{HOMEBREW_PREFIX}lib"]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    assert_match "TLS", shell_output(".buildtest")
  end
end