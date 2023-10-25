class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://ghproxy.com/https://github.com/solana-labs/solana/archive/refs/tags/v1.16.18.tar.gz"
  sha256 "05710c6cb9b9ce88ee9fb9698660e7d360a8ffc9d6dbaf56419547cf6f1fa04b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43e9f3be1638b0a4d85fb1d702a679eae5b03374ef92263c41e875a2ba3acfb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dff9efab2eba9308e18cad8379ed53665eefa01ba828bbb745760d0dd6344c93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d8a2dc8fd6ca4c4416ce73f2e2db1aaf6af3c431c1c909e728f95d09911fea4"
    sha256 cellar: :any_skip_relocation, sonoma:         "c387e6b7b2edf8f7eb8b21f9073b14b128d85df808608feab94bc7f84589a609"
    sha256 cellar: :any_skip_relocation, ventura:        "484e4a632532110bb5600db68f2d6f2eebc1704f1d663c52dfa9720e6d3d654d"
    sha256 cellar: :any_skip_relocation, monterey:       "b4e7175a6a802418f60f567982ff7217b8451bc983cd90372b57ab52ac7b5495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc95d113a5f45b3898548af943d178a3f440cc21ba009d62c200ccf4ad6a263b"
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