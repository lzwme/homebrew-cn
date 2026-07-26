class Netcode < Formula
  desc "Secure client/server protocol for multiplayer games built on top of UDP"
  homepage "https://github.com/mas-bandwidth/netcode"
  url "https://ghfast.top/https://github.com/mas-bandwidth/netcode/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "08f6e5e998ca26b733bc48b7ec0b4e3741545643eac36fe8fe78f2bf9efc0a46"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fa5ad3fb42290adf747655f2425a2328e1f5b6f6944b07826f54e9950163c8ba"
    sha256 cellar: :any, arm64_sequoia: "be3302522711cfb2979b2199d8c8a36269e8e12fede6e243cb47fadc545a6eb8"
    sha256 cellar: :any, arm64_sonoma:  "e08f40c3183cd4f3c870fe0009a121601d7b2820a425994caa4037c88c571753"
    sha256 cellar: :any, sonoma:        "0e7e51475e62de6d996a447d111896b54e502aa07be7465be84d88d252c94bc7"
    sha256 cellar: :any, arm64_linux:   "f57560434961e86d2992439f09204aa4959e657089fe04716c2edf59398c4ad9"
    sha256 cellar: :any, x86_64_linux:  "27677aa57dcb2359b8f75c26973aa5ca1d120e61c930bb2670f080b7c396f483"
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