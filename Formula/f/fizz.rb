class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https:github.comfacebookincubatorfizz"
  url "https:github.comfacebookincubatorfizzreleasesdownloadv2025.05.26.00fizz-v2025.05.26.00.tar.gz"
  sha256 "87b4aa97635c14c8d072d8e49025b2daa0e44261073a04d35cd6804c9b4b2270"
  license "BSD-3-Clause"
  head "https:github.comfacebookincubatorfizz.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "eb150241572d6b8989242e95778b2d10894515b896bb82d6d7e89e9118260f65"
    sha256                               arm64_sonoma:  "137d0fc5b83cfd4b7e4fc0c36e32f0e1cb094e763d2ee9b35ffde113138fe5c3"
    sha256                               arm64_ventura: "b5c34a11184f171a4a6c2cbc3c1d229b31bca99da66ac4228a071f61f24abec6"
    sha256 cellar: :any,                 sonoma:        "08a175b25454dbb3b7648a8e20ae21811822688b3eed02f61e8063bf7ad78393"
    sha256 cellar: :any,                 ventura:       "fe4f0eef2b5b07ad31c1a37f35ac3fd8ab77ccfc60a7e61172740e38d4af0503"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "385c1f6659e57c5a320445c5064fa8f7bb390496e9b70f280d28afec956ecca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e024f7eb24b396d54e711e73edf7445b78f51015779d3b3ee285579216429dcb"
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