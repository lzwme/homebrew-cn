class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https:www.getmonero.org"
  url "https:github.commonero-projectmonero.git",
      tag:      "v0.18.3.4",
      revision: "b089f9ee69924882c5d14dd1a6991deb05d9d1cd"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "94918e427866d89324b910d6d321ea111c08c4d216ba972a0f3dafcb0d1c920c"
    sha256 cellar: :any,                 arm64_sonoma:   "eeca3a8cd0a413a37165bf9b1534043bc3a7de27ceb3a2da218a5e4c8cd69c8c"
    sha256 cellar: :any,                 arm64_ventura:  "793f709451ab5f541d19ace5709d24eba53da6776ad99634d16b84b0e3af22b1"
    sha256 cellar: :any,                 arm64_monterey: "4f8f11e019d08e94dfb67b09f71b7bbf544fd5d6291e18d1f9b3b01d3a74dd4c"
    sha256 cellar: :any,                 sonoma:         "41430b038afff312bf9940478ed205d256229584f94a50e0061f512164f1710a"
    sha256 cellar: :any,                 ventura:        "5164d5a74ddb315555225b3c794a003f11c78c990d4b29e2d77c819bdf087e2d"
    sha256 cellar: :any,                 monterey:       "8515f6ecfc5c68d760edfdb87093a9f15191162f5872e65e1993e56d8393a46b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9066d4d2012600da453f2238eb0f1de978cfc8d8cefa6548f0ef27fa6162347d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost@1.85"
  depends_on "hidapi"
  depends_on "libsodium"
  depends_on "libusb"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

  conflicts_with "wownero", because: "both install a wallet2_api.h header"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  service do
    run [opt_bin"monerod", "--non-interactive"]
  end

  test do
    cmd = "yes '' | #{bin}monero-wallet-cli --restore-deterministic-wallet " \
          "--password brew-test --restore-height 1 --generate-new-wallet wallet " \
          "--electrum-seed 'baptism cousin whole exquisite bobsled fuselage left " \
          "scoop emerge puzzled diet reinvest basin feast nautical upon mullet " \
          "ponies sixteen refer enhanced maul aztec bemused basin'" \
          "--command address"
    address = "4BDtRc8Ym9wGzx8vpkQQvpejxBNVpjEmVBebBPCT4XqvMxW3YaCALFraiQibejyMAxUXB5zqn4pVgHVm3JzhP2WzVAJDpHf"
    assert_equal address, shell_output(cmd).lines.last.split[1]
  end
end