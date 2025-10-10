class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/downloads/#cli"
  url "https://downloads.getmonero.org/cli/monero-source-v0.18.4.3.tar.bz2"
  sha256 "6ba5e082c8fa25216aba7aea8198f3e23d4b138df15c512457081e1eb3d03ff6"
  license "BSD-3-Clause"

  livecheck do
    url "https://downloads.getmonero.org/cli/source"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0a503ca2da58ac2cc9e8ee8b5094405c13cf66bffe19b01c708f24cbb9e517cd"
    sha256 cellar: :any,                 arm64_sequoia: "c030d0c005c518e099c7550701b76b6ebdd32e91713f5ea11b9dfa8cdbe1dc97"
    sha256 cellar: :any,                 arm64_sonoma:  "0e34e02aefe0c4f89e7a130ffac64ef212eb99786825b97d47bf587488451659"
    sha256 cellar: :any,                 sonoma:        "404f91b2d016fe784c7c5ed76d4aef06e0bdc69bb2d799d2190a0337d25ca75c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3f4578ebc42cea23753fcee740b47600f36919e5307928929801c254910a84c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba360aba976bc4ea77bd9e9f849e9f79e3a8ddc6a9fb855b6405da4071df1087"
  end

  head do
    url "https://github.com/monero-project/monero.git", branch: "master"

    depends_on "libusb" # TODO: use on stable in 0.19 (?)
    depends_on "protobuf" # TODO: use on stable in 0.19 (?)
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "hidapi"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

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