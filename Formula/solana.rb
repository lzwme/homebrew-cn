class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://ghproxy.com/https://github.com/solana-labs/solana/archive/v1.14.20.tar.gz"
  sha256 "0a8119bbe2bdb35336830587227e0d472a23cb9bea69377c7393031450b771d5"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d84c8fc99a249ff55f235345aff4062cdc3a3f16d16caaaea0cdfa1ac25457a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e64f4f609643e596a52fa1470b744be91e279301bf4641a9f247afcbc4f8f23d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3266fee6c46618c9fdad241c29e69af17f8feadc45f51f5bf2b2291ef89c7ef"
    sha256 cellar: :any_skip_relocation, ventura:        "f608df7b16b29cf464eb8e82fa6dc5bb26c7bc3bfe06f65396c55bea32737b13"
    sha256 cellar: :any_skip_relocation, monterey:       "123b758a6321a876007b7258a6b3b61391786ba4e2eda633049dfa0e7b746afd"
    sha256 cellar: :any_skip_relocation, big_sur:        "c659fbd9c5b7efaec484430f249ec52202f50bfce88bbb9982e226f24508fa6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "088701ee0694b495e3aa48b563bdab94a3e31d27f0d873c37f32117814965f99"
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