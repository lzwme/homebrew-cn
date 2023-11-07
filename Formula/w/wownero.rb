class Wownero < Formula
  desc "Official wallet and node software for the Wownero cryptocurrency"
  homepage "https://wownero.org"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://git.wownero.com/wownero/wownero.git",
      tag:      "v0.11.1.0",
      revision: "1b8475003c065b0387f21323dad8a03b131ae7d1"
  license "BSD-3-Clause"
  revision 2

  # The `strategy` code below can be removed if/when this software exceeds
  # version 10.0.0. Until then, it's used to omit a malformed tag that would
  # always be treated as newest.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :git do |tags, regex|
      malformed_tags = ["10.0.0"].freeze
      tags.map do |tag|
        next if malformed_tags.include?(tag)

        tag[regex, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a7ddf9572a4d37076d0b2de404f3659b6a67fc0a5e031fffa46db720e3b4a436"
    sha256 cellar: :any,                 arm64_ventura:  "46d0b648be5f203ae20f11a4f173b8ead9f48d20069e8dc0fb4d7413c1739881"
    sha256 cellar: :any,                 arm64_monterey: "d9658e656eb77e85ec991484a229d9bb540f02d9fb8b50a8973926e04176e79a"
    sha256 cellar: :any,                 sonoma:         "0d5219873c3e3cb11f622686ca8dcc6cf7dfbc4ddb0cecfae420d56f0124b8a0"
    sha256 cellar: :any,                 ventura:        "1b96c049d6b7464e153315e2f23d8c50806007d5107b1caef8057930fece5a4d"
    sha256 cellar: :any,                 monterey:       "29560e1660379fe6bd016b1725408e9c9bfdab517b0cb9805ff4bbe203519032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6f7b775903db46ea668fec2f208a98517df13e641ef76e8bf4ff9d840c43e2d"
  end

  depends_on "cmake" => :build
  depends_on "miniupnpc" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "hidapi"
  depends_on "libsodium"
  depends_on "libusb"
  depends_on "openssl@3"
  depends_on "protobuf@21"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

  conflicts_with "monero", because: "both install a wallet2_api.h header"

  def install
    # Need to help CMake find `readline` when not using /usr/local prefix
    args = %W[-DReadline_ROOT_DIR=#{Formula["readline"].opt_prefix}]

    # Build a portable binary (don't set -march=native)
    args << "-DARCH=default" if build.bottle?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  service do
    run [opt_bin/"wownerod", "--non-interactive"]
  end

  test do
    cmd = "yes '' | #{bin}/wownero-wallet-cli --restore-deterministic-wallet " \
          "--password brew-test --restore-height 238084 --generate-new-wallet wallet " \
          "--electrum-seed 'maze vixen spiders luggage vibrate western nugget older " \
          "emails oozed frown isolated ledge business vaults budget " \
          "saucepan faxed aloof down emulate younger jump legion saucepan'" \
          "--command address"
    address = "Wo3YLuTzJLTQjSkyNKPQxQYz5JzR6xi2CTS1PPDJD6nQAZ1ZCk1TDEHHx8CRjHNQ9JDmwCDGhvGF3CZXmmX1sM9a1YhmcQPJM"
    assert_equal address, shell_output(cmd).lines.last.split[1]
  end
end