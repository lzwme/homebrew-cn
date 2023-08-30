class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://ghproxy.com/https://github.com/solana-labs/solana/archive/v1.14.25.tar.gz"
  sha256 "c181d080e95154be4a8a163dde8b34f00be577e33294f9dc4b8c93f03ca3ecd9"
  license "Apache-2.0"
  version_scheme 1

  # This formula tracks the stable channel but the "latest" release on GitHub
  # varies between Mainnet and Testnet releases. This only returns versions
  # from releases with "Mainnet" in the title (e.g. "Mainnet - v1.2.3").
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]
        next unless release["name"]&.downcase&.include?("mainnet")

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c369445b60095d661c0f8d0f5d57499a044239f53fbcddc734ce0e54d46091d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e48e78b0302f101a0fa70e63661e11607f1921ed466f7679e317d11a599d59ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12d233d30816416612162e1ded0b4187ae24c2ae587e5766401cb98d48d077b7"
    sha256 cellar: :any_skip_relocation, ventura:        "b6b2c2b0d3ba34790ff57b5bf6440d56347b6d3985b7d6db9e7c6b93e1b3fd03"
    sha256 cellar: :any_skip_relocation, monterey:       "76aa592f40996944d572f97300fa1d8cb8f7aa5fb6845c2b177d3d85564f2595"
    sha256 cellar: :any_skip_relocation, big_sur:        "c051a2c003a19cc68cd14fb13acbb7c152f7a43a461df72873a1d4bfb17e5464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4384483c714d27df33a7b99ec3edd7af2d1c0e978dfd70f92f0a93690b0bb0e1"
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