class Netcode < Formula
  desc "Secure client/server protocol for multiplayer games built on top of UDP"
  homepage "https://github.com/mas-bandwidth/netcode"
  url "https://ghfast.top/https://github.com/mas-bandwidth/netcode/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "f0e2dd9ee69cb8fdb4438eb985d290a77edb743f397ad65da23b040ac4aa7cae"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "88ad9a693e824c55b440bac3cd998b8ac2b48fce7279e7bac0cf674db310f848"
    sha256 cellar: :any, arm64_tahoe:       "608699dca99f5bedea31d89f9971628310d7290926bfdcc2513480adc1cc7fca"
    sha256 cellar: :any, arm64_sequoia:     "07fee9ca5d0d77724934f361c6c89d3476a20b22c1dd8ac731803a187cb94c18"
    sha256 cellar: :any, arm64_sonoma:      "a2d2fa90e65501ce9fc5a863835db02ac992ef44d1d8db335fc75f0f49fab190"
    sha256 cellar: :any, arm64_linux:       "4edac38d740b28ab6b27e97e1234d7b97c513e1408cb940409f127ed74312f00"
    sha256 cellar: :any, x86_64_linux:      "4a72abc5856cc675b415416bcf61db870bfc5fb8f4479755bef06a45d86ea6b6"
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