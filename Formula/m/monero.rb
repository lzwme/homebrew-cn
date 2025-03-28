class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https:www.getmonero.orgdownloads#cli"
  license "BSD-3-Clause"
  revision 1

  stable do
    # TODO: Remove `boost@1.85` and move `boost` out of HEAD in next release
    url "https:github.commonero-projectmonero.git",
        tag:      "v0.18.3.4",
        revision: "b089f9ee69924882c5d14dd1a6991deb05d9d1cd"

    depends_on "boost@1.85" # Boost 1.87+ issue ref: https:github.commonero-projectmoneroissues9596
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f64926ffcec81585860747ea20accb5a9d702bcc3cfc54d6b82088b09e67e9c1"
    sha256 cellar: :any,                 arm64_sonoma:  "d197965c50af4b4b8b76795f86b9e04f4b1d12bbf078d28847fe84e64b134908"
    sha256 cellar: :any,                 arm64_ventura: "af7b42d0daf0502281f49d547c7705ae52c484215fc937ea43570778ace0a3ba"
    sha256 cellar: :any,                 sonoma:        "db50b874db8413f84d77ed19e36cbf80c91beb82102f8c180c566b02be22498c"
    sha256 cellar: :any,                 ventura:       "70bce68c8855b46288b652b3fd608074f8cfe9533f54d728afae4f7dabf75bdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e39e7a8b79f8c13ba55872e5f389a76fee2ca3741e43deee0c6b21c830b8079"
  end

  head do
    url "https:github.commonero-projectmonero.git", branch: "master"

    depends_on "boost" # TODO: use on stable in 0.18.4.0
    depends_on "libusb" # TODO: use on stable in 0.19 (?)
    depends_on "protobuf" # TODO: use on stable in 0.19 (?)
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "hidapi"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

  conflicts_with "wownero", because: "both install a wallet2_api.h header"

  def install
    # Boost 1.87.0 fix has been backported to release-0.18 branch so should make it into 0.18.4.0
    # Ref: https:github.commonero-projectmonerocommit01bcd52924244ec8d2a24c10fcef8959289d09ff
    # Ref: https:github.commonero-projectmoneroissues9758
    odie "Remove `boost@1.85` and move `boost` out of HEAD!" if build.stable? && version >= "0.18.4.0"

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