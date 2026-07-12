class Netcode < Formula
  desc "Secure client/server protocol for multiplayer games built on top of UDP"
  homepage "https://github.com/mas-bandwidth/netcode"
  url "https://ghfast.top/https://github.com/mas-bandwidth/netcode/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "cbf1f543621d67c66301287e5b6e656d7a6df71f8d5f0e31fae1849d1f079174"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "37b9967901f8f1abdd9146ab04204232fa486f71d118bfd1530cf0a237394862"
    sha256 cellar: :any, arm64_sequoia: "2f7a8410d02f3c8c9389890c2dc016f44a1ad6eafb69b780e1c6cd0d33a3ea6d"
    sha256 cellar: :any, arm64_sonoma:  "fcf8698515a2741a12ab07d454ee9873fadce3b14d4f03786b43d265f01766cd"
    sha256 cellar: :any, sonoma:        "7d366c2374ac68491f8b5e1c4bc0aa34fb6c786a94efd2fe61ce6f12839a3cdc"
    sha256 cellar: :any, arm64_linux:   "70f5c8d20a16a063a9a1b95b385d10b57e7948e6993ebae67a2f8a7f7d91a1f3"
    sha256 cellar: :any, x86_64_linux:  "1dc906de2f96decd5124a28c0a3d2c028e6546c30da506970cc70c6b3649270b"
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