class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://ghproxy.com/https://github.com/solana-labs/solana/archive/v1.14.22.tar.gz"
  sha256 "dcf8416083029b14f4858a7a1b6fbee5a64db99ce6b9dbec6270399b9f7734e4"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "144e0017c20dcbaa736b8c894591cfb1201c4391cf385ed27e76e72d29ad3ad0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88af0b3fc1e48e18ef3ee33febefeca885626afedfdf2adb6bb9650d8fd80c62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6af43d32181ff96a3295fdd8b7a350ba4e4d9a7b5bc310fd98a372aeb77afd01"
    sha256 cellar: :any_skip_relocation, ventura:        "057f019900507f310fb4d9296415f64438bead648f1397af8067c11bc1b8342f"
    sha256 cellar: :any_skip_relocation, monterey:       "9b5237b4c6a119d01bbe0f1077db4c59b4ca02eaf746c1f3eb875d61df4a7619"
    sha256 cellar: :any_skip_relocation, big_sur:        "13de1cecbf99a9e4922494e5522efdd614c8f6e8a8f3b09c1f434f51df580139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4de7227c572a635ce32c3e7b49dcd74159795015bcffbedc0cd12a330f6754bc"
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