class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https:github.comfacebookincubatorfizz"
  url "https:github.comfacebookincubatorfizzreleasesdownloadv2024.08.26.00fizz-v2024.08.26.00.tar.gz"
  sha256 "551523d0630c51f9df38c1e3029403299aad2540bf06b78fda69ccae56db6d5d"
  license "BSD-3-Clause"
  head "https:github.comfacebookincubatorfizz.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "3d8a91cfe4802bd9b3d56aa7b8fe812e7f7457708617c473c7239a2c5911f24c"
    sha256 cellar: :any,                 arm64_ventura:  "31aa7c93301780c9854395be52ef20e6def30ff596a4b294d5d86009289c68aa"
    sha256 cellar: :any,                 arm64_monterey: "e572b3a59435ee5c2a9fde8210b59184d6c6145ea1a54a39e4fcf6ffdb2c9c84"
    sha256 cellar: :any,                 sonoma:         "8f80aedd89eb4941f7fe64154fed1dc2d4d6dd7340923ed6b083fd69b8cf01d2"
    sha256 cellar: :any,                 ventura:        "33ba6b8a1328f7632cb72a591eafc982e1b3977ed78afa7e62f06e7aedae1443"
    sha256 cellar: :any,                 monterey:       "e58084ea7fb7ee4fe28272ca071785477cce5d7e9662a30555018b4947869325"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7e975c0052dca9bbc146f105b5e7df789675d9790d21a82084a2381b1a13081"
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