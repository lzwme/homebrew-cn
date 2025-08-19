class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/downloads/#cli"
  url "https://downloads.getmonero.org/cli/monero-source-v0.18.4.1.tar.bz2"
  sha256 "e70e44cae986123c39b77a89a9ee5db431c050a55cc64442993482d085104103"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://downloads.getmonero.org/cli/source"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f276e89d5ade9c86c3f286b3878e4ac374cc1ed830ae3f991b9a825e656a0c8b"
    sha256 cellar: :any,                 arm64_sonoma:  "3717fedf0a83a5d5bd3c8c20c38207fd165939c06ed966545ba6f022b36c18be"
    sha256 cellar: :any,                 arm64_ventura: "e467fab550d5dda8f2e918413c5688019c7c674bbca436b9269466335bae780f"
    sha256 cellar: :any,                 sonoma:        "6efe62876cb29a6230032b9c8022abd5aa9bce8b7f1e29c3032c77275eb2f233"
    sha256 cellar: :any,                 ventura:       "a0962e0b212b2d248142be447aca60328d5a54bae9d2d1cb3cd89ee535470c26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe91a472f987bbee0f859ad39da920cf3460cdd84ea00e4a47be9567f952e961"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b178857c6b2da2757c165e3c33cccc85a7339df83a0de61ed9f18f0ff9b3ef8a"
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

  # Fix build with Boost 1.89.0, pr ref: https://github.com/monero-project/monero/pull/10036
  patch do
    url "https://github.com/monero-project/monero/commit/f61294dc6bd9fe65d584526138178a2419f3832a.patch?full_index=1"
    sha256 "c0da585e4f06c942c4be9c829fff5483f49204dcfb4258dea7f7c6dd9be5304a"
  end

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