class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https:solana.com"
  url "https:github.comsolana-labssolanaarchiverefstagsv1.17.33.tar.gz"
  sha256 "a9d3a3330a465d0b3395e30e019c5bc0a5a9218f59844bf9f8c7933dc2eba231"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0649a5eda6c7862000557b177129ee968d3b4fd2960dd8bdf1ff63788b255954"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b0a76e693a80e1d316bd6230a90ccf90485dfcc1291d20fe0fbce7226b80bcd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de77ea93d1b94a2da69167729074301cc92c734660a9c32c0b268618b41b8474"
    sha256 cellar: :any_skip_relocation, sonoma:         "9511fad3d0b571d7f474c795ef02b42191b91d7ab765322c0615a18a4b6c559c"
    sha256 cellar: :any_skip_relocation, ventura:        "a6291d524d4fca480524ed8f33804290ef6facdf62d791ec48c24ed30c94461a"
    sha256 cellar: :any_skip_relocation, monterey:       "776cf9c71789a05a95a49a4ca8fcc744ea8a5446f63cc6e267db726257d3ad36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "576d627e63e786c4cbec80578457b12172bd1a7538154c8223e532d8f34f2052"
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