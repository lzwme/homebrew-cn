class Netcode < Formula
  desc "Secure client/server protocol for multiplayer games built on top of UDP"
  homepage "https://github.com/mas-bandwidth/netcode"
  url "https://ghfast.top/https://github.com/mas-bandwidth/netcode/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "71f9acdf5d40816f94218df624fc1746b122f38ee070d27aa7a3abf1c4321eeb"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "218f48a5ff16fe97ff3b86721cf9684d082395a2125149ab93a518fbc5076674"
    sha256 cellar: :any, arm64_sequoia: "491135b7a8a11c91fb961a50555aecd15b47be36e5f68683fb9041a5abf95778"
    sha256 cellar: :any, arm64_sonoma:  "ccfddf6634a7552ec275357e42d32ea7d6f872596a557c5dcc762d238c146f1c"
    sha256 cellar: :any, sonoma:        "96fedc9765c4af84ceb1f684ee2d57ca26a98a24fbeb568c8f854ee0e933a6d0"
    sha256 cellar: :any, arm64_linux:   "dd121e5e3d4e1c19f6bb21cedd532b29894a31ffe592c72cac96aa789fcb3a20"
    sha256 cellar: :any, x86_64_linux:  "2f5c8354b173ccceda0cba8219cb7c82f810d7f6ebf3bb91bd3c488fdcb7ebff"
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
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnetcode", "-o", "test"
    system "./test"
  end
end