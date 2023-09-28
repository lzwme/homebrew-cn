class ClickhouseCpp < Formula
  desc "C++ client library for ClickHouse"
  homepage "https://github.com/ClickHouse/clickhouse-cpp#readme"
  url "https://ghproxy.com/https://github.com/ClickHouse/clickhouse-cpp/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "7eead6beb47a64be9b1f12f2435f0fb6304e8363823ed72178c76faf0d835801"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhouse-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8edc749190719094fa7fbb0721c61eec348222130eb3d539639eee7f4a9ec09b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c93493fda367e6632172ab9d46a1fc5b41a6e8d6fc33df334597454413ff2e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e34367cdb41dae0349cc13f08e2ca46354d86d5e1d2e6cdaf759909d172b046a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c27e926040c53929538a96497aa92fedc99010c2fbe93230a12a800b926a181b"
    sha256 cellar: :any_skip_relocation, ventura:        "b372d8d36380782eab3025272cc0c4ce409593b7ae74d8df39d34edd7479ce22"
    sha256 cellar: :any_skip_relocation, monterey:       "44fb332d4f3f294ebbbaf322bf13efbde7dcfe20b370a5bafef8ce6d837ed4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8684045cc3b68ba73fa57952d5f746fcac18fccb4d45fc7d4b0e8ca0449d0c7e"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "lz4"
  depends_on "openssl@3"

  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    # We use the vendored version (1.0.2) of `cityhash` because newer versions
    # break hash compatibility. See:
    #   https://github.com/ClickHouse/clickhouse-cpp/pull/301#issuecomment-1520592157
    args = %W[
      -DWITH_OPENSSL=ON
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DWITH_SYSTEM_ABSEIL=ON
      -DWITH_SYSTEM_CITYHASH=OFF
      -DWITH_SYSTEM_LZ4=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Install vendored `cityhash`.
    (libexec/"lib").install "build/contrib/cityhash/cityhash/libcityhash.a"
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
      -L#{libexec}/lib
      -lcityhash
      -L#{Formula["openssl@3"].opt_lib}
      -lcrypto -lssl
      -L#{Formula["lz4"].opt_lib}
      -llz4
    ]
    system ENV.cxx, "main.cpp", *args, "-o", "test-client"
    assert_match "Exception: fail to connect: ", shell_output("./test-client", 1)
  end
end