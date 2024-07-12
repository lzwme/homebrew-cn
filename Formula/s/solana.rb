class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https:solana.com"
  url "https:github.comsolana-labssolanaarchiverefstagsv1.18.18.tar.gz"
  sha256 "2e534c9dba93bf21e08c5ba6744333bd535459d944e308bdf59e036f7c007a20"
  license "Apache-2.0"
  version_scheme 1

  # This formula tracks the stable channel but the "latest" release on GitHub
  # varies between Mainnet and Testnet releases. This only returns versions
  # from releases with "Mainnet" in the title (e.g. "Mainnet - v1.2.3").
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a4925bf73cd599551265f2bd34ab77ff85f06d7e04ae06d8b6f6ddd9b62e744"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67b90b24bb58f85a1bd9ed9d7e355c58d345327d1d9fa4cd5230a124dcd227ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40618558a1d2ef9161bd2a4e191df55682742fda7fa264450c47374fc2dab2b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "d91a92fa51db05ceaf8a33a4040cdd8baf74f0c03750f008e4d3e30e71d8431d"
    sha256 cellar: :any_skip_relocation, ventura:        "fa00e798ee22cd33f88669b50f2f33cb8f3ea2176567ea8c01a09e3192fa9e57"
    sha256 cellar: :any_skip_relocation, monterey:       "7873dc2bc52b3d0a434ec9001eaed2a9547354e7d5b29c711f4a8f63024a5fa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e75b09886e90f8c29ed7ee100975715401f0ccfacd52d6199f97ee9ad3893bf3"
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
      shell_output("#{bin}solana-keygen new --no-bip39-passphrase --no-outfile")
    assert_match version.to_s, shell_output("#{bin}solana-keygen --version")
  end
end