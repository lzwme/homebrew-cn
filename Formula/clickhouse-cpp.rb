class ClickhouseCpp < Formula
  desc "C++ client library for ClickHouse"
  homepage "https://github.com/ClickHouse/clickhouse-cpp#readme"
  url "https://ghproxy.com/https://github.com/ClickHouse/clickhouse-cpp/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "336a1d0b4c4d6bd67bd272afab3bdac51695f8b0e93dd6c85d4d774d6c7df8ad"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhouse-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5d522cddfcb58177aa8838f06ca2676f6fb8f925db7df257b74375b2b0ae16c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "129076d2815b9e9db3706ef2fc2a6d58d6397749aea33373db4123c136b12398"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d00957ebb77520a38a00b2adc585473b22bbc76d80513221ccee03267999b8f"
    sha256 cellar: :any_skip_relocation, ventura:        "180b9823ab1a33dd3eee7adc2e483f5e85eb8efa78397e09f9b7a2e706c90ae5"
    sha256 cellar: :any_skip_relocation, monterey:       "feaa3c3899460b7eefd811683febd8656369acafcfb6779a71c493ccbe81ceae"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9a20f558db8842cf7df6047b8a718cf38e65c7e65308de7ba51355d8751e95b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d027b532abf0e8cb16ee988be58b30919feb22761bd3a5875de8ea8b26b5de4"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "cityhash"
  depends_on "lz4"
  depends_on "openssl@3"

  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    # `cityhash` does not provide a pkg-config or CMake config file.
    # Help CMake find it.
    # Remove when merged: https://github.com/ClickHouse/clickhouse-cpp/pull/301
    inreplace "CMakeLists.txt", "FIND_PACKAGE(cityhash REQUIRED)",
                                "FIND_LIBRARY(CITYHASH NAMES cityhash REQUIRED)"
    inreplace "clickhouse/CMakeLists.txt", "cityhash::cityhash", "cityhash"

    args = %W[
      -DWITH_OPENSSL=ON
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DWITH_SYSTEM_ABSEIL=ON
      -DWITH_SYSTEM_CITYHASH=ON
      -DWITH_SYSTEM_LZ4=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"main.cpp").write <<~EOS
      #include <clickhouse/client.h>

      #include <exception>

      #include <cstdio>
      #include <cstdlib>

      int main(int argc, char* argv[])
      {
          int exit_code = EXIT_SUCCESS;

          try
          {
              // Expecting a typical "failed to connect" error.
              clickhouse::Client client(
                clickhouse::ClientOptions()
                .SetHost("example.com")
                .SetSendRetries(1)
                .SetRetryTimeout(std::chrono::seconds(1))
                .SetTcpKeepAliveCount(1)
                .SetTcpKeepAliveInterval(std::chrono::seconds(1))
              );
          }
          catch (const std::exception& ex)
          {
              std::fprintf(stdout, "Exception: %s\\n", ex.what());
              exit_code = EXIT_FAILURE;
          }
          catch (...)
          {
              std::fprintf(stdout, "Exception: unknown\\n");
              exit_code = EXIT_FAILURE;
          }

          return exit_code;
      }
    EOS

    args = %W[
      -std=c++17
      -I#{include}
      -L#{lib}
      -lclickhouse-cpp-lib
      -L#{Formula["openssl@3"].opt_lib}
      -lcrypto -lssl
      -L#{Formula["cityhash"].opt_lib}
      -lcityhash
      -L#{Formula["lz4"].opt_lib}
      -llz4
    ]
    system ENV.cxx, "main.cpp", *args, "-o", "test-client"
    assert_match "Exception: fail to connect: ", shell_output("./test-client", 1)
  end
end