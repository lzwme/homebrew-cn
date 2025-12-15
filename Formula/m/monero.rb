class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/downloads/#cli"
  url "https://downloads.getmonero.org/cli/monero-source-v0.18.4.4.tar.bz2"
  sha256 "84570eee26238d8f686605b5e31d59569488a3406f32e7045852de91f35508a2"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://downloads.getmonero.org/cli/source"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b22361941573abc4e3a30433f7109e71d038d8d9263fa1ceda7853cd61141b51"
    sha256 cellar: :any,                 arm64_sequoia: "54b1e670e042a54085388ded9f3d97994a9db03d70e5bade2c253cd38b0765e5"
    sha256 cellar: :any,                 arm64_sonoma:  "6b794e9de314e69f227f646754c3d27916e2177421daff7280ebcbedd2484ca2"
    sha256 cellar: :any,                 sonoma:        "d3cbb64e0e18c9ebd7f1fb731e4c5cd5802e478717e925dfcde8f19e5f36efbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2544739d80f5817010f0b51f7dfdae86ef8605a9293d176e685b09f61d39e5f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba8ef29e9ea3215b2abddaab46061606522d200e23ca567cd4cf8f8aae694c25"
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