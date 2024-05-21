class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https:solana.com"
  url "https:github.comsolana-labssolanaarchiverefstagsv1.17.34.tar.gz"
  sha256 "8aca18cb037e2d1e7e61ad08b3b0d60f64cfb214b0505dbf14c9c1a1b88d4c9f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "090132f0b8733f417bb165459b98ac66018c0c2472ba95365f79bf6b0020cb8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2e66216236d87141d6a711a988ec384ede386ed28f8cc1c97d1c20d7dc70a91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c044260410ea4fdfebbc64770a5fef941cb471d533fc27673985dfe0d9fd43c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d55a786782a0182cd0295b8fba17b0139207edb78c3b6324c3fb82fc5e0b85e2"
    sha256 cellar: :any_skip_relocation, ventura:        "f22aee7706330c71eed12e30cfa8301497ea1f9e24f1a9706557066692e36593"
    sha256 cellar: :any_skip_relocation, monterey:       "a713f1f34a8e75a5d9163ed3d2bf38a4dc25fb6437f3509ee9cb69c25c1fa5b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd9adba774ae6e5c1c09c8ac79c99d9a38a2474b1bd3007c5db121ec7bcad116"
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