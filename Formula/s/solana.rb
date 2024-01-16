class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https:solana.com"
  url "https:github.comsolana-labssolanaarchiverefstagsv1.17.16.tar.gz"
  sha256 "1d44ebc853345c5153602d9a88511e795ed53ec5e89fb09038a3f8c76e2c6f93"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "009359e3f72049c550360e0a42b7b89a727362fc549e32636d62a82312eb0783"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "770af69b774dac2374f51f7ee04689b0c7798f3f7e6e203280af84d0e3646535"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f86011fb6f34b192518da7653a63d1c183e44d2a67ddb6e5d375d2f20c3e4bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbea0c77923f9e25ee38e0762cafc4b0103fbd502b8d4afaf8dc7d80357a71d4"
    sha256 cellar: :any_skip_relocation, ventura:        "61817c9d45d531598c0aa5a177dc7c993715d001375753a45f56a2a08a2c05be"
    sha256 cellar: :any_skip_relocation, monterey:       "0abf5131f7164f20787e261d8c2ab1de1b21cbda876b8c856de2b8c7520cc578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54cb95e11e896d7f4f1c95f377037d90cd8b4f686a4f718ca7b55faa7bb57a6a"
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