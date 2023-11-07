class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.18.3.1",
      revision: "2656cdf5056c07684741c4425a051760b97025b0"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "11b25c7b6eb035825512713fe759ff52e65cc87f2b5b1d004b1c53568999259c"
    sha256 cellar: :any,                 arm64_ventura:  "c864c2cf92144fe704f1a3201b5ec2a3b9fa30e4cac834bb171ec1f53b735535"
    sha256 cellar: :any,                 arm64_monterey: "5188247269ec0d15a0844f27da260dca6fb36551b8708282f1597bde0937e944"
    sha256 cellar: :any,                 sonoma:         "efb23b89e41a0677f5b780e7725ec7bfd64c9fa70a13b21c229569b27740e9fa"
    sha256 cellar: :any,                 ventura:        "ef8a281eba2a86c873aec3a6a44191d4cbbad2ed051cbb9d081d4a37884b2a23"
    sha256 cellar: :any,                 monterey:       "981cf50d2c92b39f8fa34ab2f2ea5db7a22842ba908cd8688953b65cb2894ead"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33d86d52c3f325364733563cb58e9796d8096425078d8d8b3359f4220ab46a83"
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