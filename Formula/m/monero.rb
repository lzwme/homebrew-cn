class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.18.3.1",
      revision: "2656cdf5056c07684741c4425a051760b97025b0"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "90279280450a2c450e65b94fbceb2972c7e7d7c19aa9e8dcc11b271ee600affe"
    sha256 cellar: :any,                 arm64_ventura:  "1b3792d4f759c901c776cb2bc1d03ef6661e253f30e584a76ebb3af4c07c6071"
    sha256 cellar: :any,                 arm64_monterey: "bd283ffde4a292692be6ffed9cbd4525f6f683c7e383c968c8d722af7b7a991e"
    sha256 cellar: :any,                 sonoma:         "869c628d280ede1f9cf06e81224bc9aeaafb994566f4afd60876c22826887aea"
    sha256 cellar: :any,                 ventura:        "75c3db596e2ae2be0437217586f7ce302790896a3db93d1a5bb2bbd74b65fd71"
    sha256 cellar: :any,                 monterey:       "b57d321aedbfa90abd154a88cb95ecd89bcd1e167b58b6793868a5b85b003d38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ab52123f9ba7d2b60641f9601333cbb2ac270ef2e14c7beb2aa9e8cd7aa1b47"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
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
    run [opt_bin/"monerod", "--non-interactive"]
  end

  test do
    cmd = "yes '' | #{bin}/monero-wallet-cli --restore-deterministic-wallet " \
          "--password brew-test --restore-height 1 --generate-new-wallet wallet " \
          "--electrum-seed 'baptism cousin whole exquisite bobsled fuselage left " \
          "scoop emerge puzzled diet reinvest basin feast nautical upon mullet " \
          "ponies sixteen refer enhanced maul aztec bemused basin'" \
          "--command address"
    address = "4BDtRc8Ym9wGzx8vpkQQvpejxBNVpjEmVBebBPCT4XqvMxW3YaCALFraiQibejyMAxUXB5zqn4pVgHVm3JzhP2WzVAJDpHf"
    assert_equal address, shell_output(cmd).lines.last.split[1]
  end
end