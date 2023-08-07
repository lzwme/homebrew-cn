class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://ghproxy.com/https://github.com/solana-labs/solana/archive/v1.14.23.tar.gz"
  sha256 "c5430a981d78de16ffe7f224c0e3bc60ba5333c67cbcd81a493c4ade44027e10"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75df3c347d9b22cabc907bf7288986252a925fac1db53e421ba9f5a86f87f7ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c2e18b5128ef3d7583a9895739e71428541dcbf36c4b39e1dd8bb87f49e1290"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "519f8a0bc9184cc0bdaff797aaf4a76f7d05c2f173e400b3f7b42ca8a969b980"
    sha256 cellar: :any_skip_relocation, ventura:        "8526906cacae182e4c9c91239b8942f78c560d9de9f9319bd9b2ffd4b3f5793e"
    sha256 cellar: :any_skip_relocation, monterey:       "2294d971c2d87962dd380f99c0cb9ed09b6e6459161f58f444a7360dc46dbc52"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9d4c418d909c6e19cc2ee2ff822d0e5b77157c7fb45b299a7ede8dd2411d150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13779cd1cc43e945cc2e7a7619880479e407829e4b5c0eeeb17bd899b65200f4"
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