class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https:solana.com"
  url "https:github.comsolana-labssolanaarchiverefstagsv1.17.18.tar.gz"
  sha256 "b532c38e81f520d05e3f79fae3a4bc7f1a37d201263ff604aabe99b37901bc3f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1b28bb0c67a820e9c0ba27ba5f6a58d17b06f930412d299135a0474836f8826"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee0485f5a1a66f2f428ffaeb99f305f02c9e3eadbb4b8408b9c40c481cb61e99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0de1595ea94816b9b2fc39880ced632f236b8bac5e7a1c89203ba158c9d8d3c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b526a3b621dc8b81468960d29b49c077959176423c99cbbf6fd657140c37ee9"
    sha256 cellar: :any_skip_relocation, ventura:        "c961f67fad838161cf06c5467426ba87e5fbecff831bb2528519a0db0f08334f"
    sha256 cellar: :any_skip_relocation, monterey:       "663bff849e5e38f7d22046d86287835dd37a02491732a158f53f2df2be631c44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e65b094a37d7785eb989857b8641947fd5407e830c2d9664c0c47b6fea06c9d3"
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