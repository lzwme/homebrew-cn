class Netcode < Formula
  desc "Secure client/server protocol for multiplayer games built on top of UDP"
  homepage "https://github.com/mas-bandwidth/netcode"
  url "https://ghfast.top/https://github.com/mas-bandwidth/netcode/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "b21995f192fcc0252cccfa2a584dfab3509172741e9a1eeb58baf514b9747c92"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "aed81be23962b53043461b6f2b6b3fe515a2ec20f194cc59ce9d36264ba08903"
    sha256 cellar: :any, arm64_sequoia: "4065f5751057dcae095e789f77721a01e549a3bbae60ee01165b9f0c52e45328"
    sha256 cellar: :any, arm64_sonoma:  "4c5644518debf9f6a9bfbec99d1f5cb8ef52b581f04dc11e4f8c702133c152bd"
    sha256 cellar: :any, sonoma:        "f3c741f2857c0c27cfa9f7172dd13c6a048026a1076fe32ff4c5759bcc888275"
    sha256 cellar: :any, arm64_linux:   "db5ce47fec191187ad10e8fb5ca92a4915bc4ea318aed6972ec0088b93a85039"
    sha256 cellar: :any, x86_64_linux:  "f8ade1334eda200e29ec02c4a352b7e98ed12f3936b4d572070c57ce48b4207f"
  end

  depends_on "cmake" => :build
  depends_on "libsodium"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DNETCODE_SYSTEM_SODIUM=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <netcode.h>

      int main(void) {
        if (netcode_init() != NETCODE_OK) return 1;
        struct netcode_address_t address;
        if (netcode_parse_address("127.0.0.1:40000", &address) != NETCODE_OK) return 1;
        if (address.port != 40000) return 1;
        struct netcode_server_config_t config;
        netcode_default_server_config(&config);
        struct netcode_server_t *server = netcode_server_create("127.0.0.1:40000", &config, 0.0);
        if (!server) return 1;
        netcode_server_start(server, 16);
        if (!netcode_server_running(server)) return 1;
        netcode_server_destroy(server);
        netcode_term();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnetcode", "-o", "test"
    system "./test"
  end
end