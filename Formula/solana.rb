class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://ghproxy.com/https://github.com/solana-labs/solana/archive/v1.14.21.tar.gz"
  sha256 "ca816f7c0009e99d0b6647d28645ef2b93c507ab305f16da88380dc6f6bb2b71"
  license "Apache-2.0"
  version_scheme 1

  # This formula tracks the stable channel but the "latest" release on GitHub
  # varies between Mainnet and Testnet releases. This identifies versions by
  # checking the releases page and only matching Mainnet releases.
  livecheck do
    url "https://github.com/solana-labs/solana/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >][^>]*?>\s*Mainnet}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5812ec736742d7e1e1dd2f22f779e1e743c8a36d1400faf3a72c148c9ea636da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65609ffdc5d476a58a2e20c91d9f73b5247e82dfe7828d2e78d8d375616024b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de4582fa27055264b75f456e3b2b3d934a86797cbb9f6d20d81ac0dbc1113970"
    sha256 cellar: :any_skip_relocation, ventura:        "b361b0fab193584e216ad3c06a5056473b820dd8ac8ce7021d6b35981d9450a7"
    sha256 cellar: :any_skip_relocation, monterey:       "631eab5b3fee5323fa505c1c97d7daffb21f4184e16368b262ba84d4ac5b6f58"
    sha256 cellar: :any_skip_relocation, big_sur:        "5439d7ed449718ad508dbcc5300224c3c2fab7bac3dc9ffd18eb2bbfc59c9d1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "416a34811dac5456651eeab7ea0b8bf20f0024be3b010d9ee3203b2a7a4fd296"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "systemd"
  end

  def install
    %w[
      cli
      bench-streamer
      faucet
      keygen
      log-analyzer
      net-shaper
      stake-accounts
      sys-tuner
      tokens
      watchtower
    ].each do |bin|
      system "cargo", "install", "--no-default-features", *std_cargo_args(path: bin)
    end
  end

  test do
    assert_match "Generating a new keypair",
      shell_output("#{bin}/solana-keygen new --no-bip39-passphrase --no-outfile")
    assert_match version.to_s, shell_output("#{bin}/solana-keygen --version")
  end
end