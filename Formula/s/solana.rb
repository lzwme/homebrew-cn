class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://ghproxy.com/https://github.com/solana-labs/solana/archive/v1.14.27.tar.gz"
  sha256 "678395a6a4e27546f7104b8a500098d35c64ea2a80088e17413e03f44acf3cda"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb0d56b493bbf22ca46ed859576b6d37da7651bd380944f734a1408c92423f9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b4f9c5f847e3f5677590b5ab05992d5264d498c3465a8f4f2b54034ce00f74c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c802ec4741f1492ad251974696dcc09cae3b060c1abf1478578bbe6aeed47cd"
    sha256 cellar: :any_skip_relocation, ventura:        "9be3807e7c41296eeeeed7fb1b20d20bf1663bd3aa51b69a9bcb8a15561e9170"
    sha256 cellar: :any_skip_relocation, monterey:       "eb95668eebf08a5daafc7a6c206ddc18a0bd971d8563b3ae3698f2ebf6969b99"
    sha256 cellar: :any_skip_relocation, big_sur:        "efa3812b0ca350027f9e9aaa71f62efa4604155f9b5f1b80dcc9a472fdff18f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d900db872a99b3e8947dec0951bf42083d2ae2a2107c157d2b9baa8616f03044"
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