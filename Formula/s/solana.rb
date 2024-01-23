class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https:solana.com"
  url "https:github.comsolana-labssolanaarchiverefstagsv1.17.17.tar.gz"
  sha256 "ed99471a0a1c852ec3605dd2c46529ba96f7e673e6a2e6f1c104e605c4761dda"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4433d03f4c2783db7f92e1dea11ee356d019c6c881e29fbb58bc868d8f73c2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e051d98bc98cc68a11381fb2629de956f148eccac53d3658b5d682f527198e03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72c0c195485ce919af4cab92f846729ec155553b5fbf47403ec7bc4dccfa72c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "484e508e501311113b68dd01f312c7536e52d46075647916779cb6d3185dddbf"
    sha256 cellar: :any_skip_relocation, ventura:        "0a2dc9d4509e64cbeb3534846c23f42ed76819212ddfcb11c341d46b3c1b3545"
    sha256 cellar: :any_skip_relocation, monterey:       "d383e13529350d6b2d332872bacea0e2297b67622ac7bed284cce164c941c44b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "920adcfe1bfc21184491c7366feea5f935eb91311aab6f1e6cd74992392d0d9a"
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