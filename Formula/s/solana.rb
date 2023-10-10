class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://ghproxy.com/https://github.com/solana-labs/solana/archive/refs/tags/v1.16.16.tar.gz"
  sha256 "fd7d9ddda50b7809138c0799620fec57e77ec375fc8918535edb97ca77641529"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc2f3c6eca550db104625208942eb4b3cf46b5255a0901c56dee5b427971f7bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8e7a5aaef294bef32eed2d65cd27d70d6b06935ff4ded8e70220ffb31c4b14a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3e8e491293ac76ab946b8f2751a13a70e5258d8d3ff024f76e297b0a1ec52b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "883f148fdd521566240a76094e957cf1a4cd9ab33ba456b4dd68dcdfd3f2e2f5"
    sha256 cellar: :any_skip_relocation, ventura:        "679ef82efd722f7e983a6490d532bff89162b94632f13a92b513699ddc91f097"
    sha256 cellar: :any_skip_relocation, monterey:       "ec737670f96f7e395c9e371cfbede9712875e0692f154eefe4155c5c19a50d42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5929b346d541d8bbfee2b7d358046a77a1c00ba39b07e01f46405bc533cd527"
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