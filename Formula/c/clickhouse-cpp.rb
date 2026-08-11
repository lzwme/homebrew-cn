class ClickhouseCpp < Formula
  desc "C++ client library for ClickHouse"
  homepage "https://github.com/ClickHouse/clickhouse-cpp"
  url "https://ghfast.top/https://github.com/ClickHouse/clickhouse-cpp/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "bac497857759e991fa4e1638bccf936cb36d10ad79273695a570272cc4891428"
  license "Apache-2.0"
  revision 1
  head "https://github.com/ClickHouse/clickhouse-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37ca89079fefc10f2cf686da11d36e5f4495a7906283c21d67bbb5c3bfe1702e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6429bb137ec8ac420b6bebf958725f78a4f851cfa78f16a529d751e75b52627b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8eaef3c9de5312c4aedfde5d9449fa4bf07825a701282de9bc0e466600044ff2"
    sha256 cellar: :any_skip_relocation, sonoma:        "33bfa318c532cc02c9a98fc9961872e769014f5cf5c73e7f8d22768ddcda2ca6"
    sha256 cellar: :any,                 arm64_linux:   "d3639f10f9fcae002b9567249d3ad618150e70f0ee50d6bb739d1ad2326a8d84"
    sha256 cellar: :any,                 x86_64_linux:  "9b52025f5185d3b85666a5f485d7a9fc94545ef31d0e8115f76f1835c89d3e5f"
  end

  depends_on "cmake" => :build
  depends_on "abseil" => :no_linkage
  depends_on "lz4"
  depends_on "openssl@4"
  depends_on "zstd"

  def install
    # We use the vendored version (1.0.2) of `cityhash` because newer versions
    # break hash compatibility. See:
    #   https://github.com/ClickHouse/clickhouse-cpp/pull/301#issuecomment-1520592157
    rm_r(Dir["contrib/*"] - ["contrib/cityhash"])
    args = %W[
      -DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@4")}
      -DWITH_OPENSSL=ON
      -DWITH_SYSTEM_ABSEIL=ON
      -DWITH_SYSTEM_CITYHASH=OFF
      -DWITH_SYSTEM_LZ4=ON
      -DWITH_SYSTEM_ZSTD=ON
    ]
    # Upstream only allows building static libs on macOS
    # See: https://github.com/ClickHouse/clickhouse-cpp/pull/219#issuecomment-1362928064
    args << "-DBUILD_SHARED_LIBS=ON" unless OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"main.cpp").write <<~CPP
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
    CPP

    args = %W[
      -std=c++17 -I#{include} -L#{lib} -lclickhouse-cpp-lib
      -L#{formula_opt_lib("openssl@4")} -lcrypto -lssl
      -L#{formula_opt_lib("lz4")} -llz4
      -L#{formula_opt_lib("zstd")} -lzstd
    ]
    args << "-lcityhash" if OS.mac?
    system ENV.cxx, "main.cpp", *args, "-o", "test-client"
    assert_match "Exception: fail to connect: ", shell_output("./test-client", 1)
  end
end