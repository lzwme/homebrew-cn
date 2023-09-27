class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://ghproxy.com/https://github.com/solana-labs/solana/archive/refs/tags/v1.16.14.tar.gz"
  sha256 "5751a150197dc82c613e3ad93d94b4cc5eae8fba4b07bff5943a770536968c72"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c319dd1257dba91a9efc9af51710fcd1aa0dbe3ce085fd0cd9685681012087c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "760655bdae30cf276d0a2ccd9c915342d82d87ee9bed8192b3ee3e9ff48035ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70d209f1753a9b24831c446aef9219435dfb2af9f28c7bd146351ea130d85f88"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4e0e622044598fab6ca7cf2d75017d35d9fd6c446e459721160b39e2acc9faf"
    sha256 cellar: :any_skip_relocation, ventura:        "e1f632ee5136a9509f584c04d15ccac1eefbae4e1bcbcb110663450a86c9c962"
    sha256 cellar: :any_skip_relocation, monterey:       "2c717c5baedc6d45e7fab347b6968ab60fb2dbcafbe8a185cfa106772d91053f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1abe55362247b4e73fe5b71ddeeb6417c249a3169809a653c40222b2e40b4b58"
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