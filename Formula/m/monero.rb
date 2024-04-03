class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https:www.getmonero.org"
  url "https:github.commonero-projectmonero.git",
      tag:      "v0.18.3.3",
      revision: "81d4db08eb75ce5392c65ca6571e7b08e41b7c95"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "706b507865029e3b6ec2a1a2e3d3507ad21e814cb473ac2ad87a64a58c94c4c1"
    sha256 cellar: :any,                 arm64_ventura:  "cf313467e731f2e71268a1123465071ddd889b90bb4a7461fe8f74dc82016f17"
    sha256 cellar: :any,                 arm64_monterey: "b6ecfa6607a5489696af1d8c934eeb986e1f10be4200acaf0808e6750b691f68"
    sha256 cellar: :any,                 sonoma:         "a614430ff6314b63cd1856b44ef27c4d1539dd17d9927e49ae7b0f2ebf681954"
    sha256 cellar: :any,                 ventura:        "1a28d6dc91dabc6f573cf743e193601b6621fb303e62e04822762e81c744c575"
    sha256 cellar: :any,                 monterey:       "358be0c497d426647eee31788db9da773c4f5d4e92955c2ec901b75739e08e82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04339d3ef5a6425da8b45eafd52e2485e68534f52cab9518dab2b5625b8cfa2e"
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