class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https:solana.com"
  url "https:github.comsolana-labssolanaarchiverefstagsv1.17.20.tar.gz"
  sha256 "2d9039846722eb3934d1019cd0e94586bf5f82e3a9a4c97a04e96e3b0b8cf6e3"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c92d3c4cae2df1bfe7d1f96cc7151965ede169692b4244bf1088343b2c549831"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a55da926a7f417841116b5dd6bd2f7dd20f1b743a0244de872d45036e52af21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e714f70357bfdfefd3ed93e8250fc3f38c6f5709cd161caaec1f848931dc749d"
    sha256 cellar: :any_skip_relocation, sonoma:         "48615639788e00f80d775438afad5e8d72e3d634591f51d41e9d104c9133eade"
    sha256 cellar: :any_skip_relocation, ventura:        "06c05784b90d4b724944115ef2f7de51cf388c9f9fa92d7ca9802af205203050"
    sha256 cellar: :any_skip_relocation, monterey:       "869a4b4b4f71883e9424d0933fde0b37386d8d79ed9e75f50d01335f4d07b2c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "898296c73c246ca6019b847fa7b0355376a22a46f2ab1b47eceb437fbe24769d"
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