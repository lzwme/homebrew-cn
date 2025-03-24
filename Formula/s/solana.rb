class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https:solanalabs.com"
  url "https:github.comsolana-labssolanaarchiverefstagsv1.18.20.tar.gz"
  sha256 "909000aab630d73c566f1573436e6a656e80528bd57a067e79e80fbe58afcd07"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "587663fffc9f10da1338bd74511ee9997dab9283353b6f1cc57dc52e5dedca0f"
    sha256 cellar: :any,                 arm64_sonoma:  "dc737b2805e44862c7d71a09646f65646744ae2e720767a3b8b864f8789c1b21"
    sha256 cellar: :any,                 arm64_ventura: "f168f86719af5f2eda08655be0ca639aa8ffa24d666af60f3c350296de8ac7a0"
    sha256 cellar: :any,                 sonoma:        "bf2095088594fdf9c04698c0b274dc4933afecfec472570a09fc05d560048ef1"
    sha256 cellar: :any,                 ventura:       "98ecdf1700ab37071fffef07518908e80168a1b77cda03a66d18880fccb66cfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd0f91388df10d9e4f452fa7a13070d2d8cbf0212474ad5074df19fe732bdc01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e327904665e09bb0beb049379e085cdf2c7ecfec1af44fdfd8eb60c664777a5a"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  uses_from_macos "llvm" => :build # for libclang
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
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

    # Note; the solana-test-validator is installed as bin of the validator cargo project, rather than
    # it's own dedicate project, hence why it's installed outside of the loop above
    system "cargo", "install", "--no-default-features",
      "--bin", "solana-test-validator", *std_cargo_args(path: "validator")
  end

  test do
    assert_match "Generating a new keypair",
      shell_output("#{bin}solana-keygen new --no-bip39-passphrase --no-outfile")
    assert_match version.to_s, shell_output("#{bin}solana-keygen --version")
  end
end