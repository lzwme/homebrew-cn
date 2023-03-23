class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://ghproxy.com/https://github.com/solana-labs/solana/archive/v1.13.6.tar.gz"
  sha256 "b4dc483102cddc683a22ec235af5ceb7f5a3bbe8054a5019648f33367b7e9a92"
  license "Apache-2.0"
  version_scheme 1

  # This formula tracks the stable channel but the "latest" release on GitHub
  # varies between Mainnet and Testnet releases. This identifies versions by
  # checking the releases page and only matching Mainnet releases.
  livecheck do
    url "https://github.com/solana-labs/solana/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >][^>]*?>\s*Mainnet}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bef198b54cbba996b68ef6a0d3d351efd67a7dac9dc56c97769151ea673258b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "012e0bca4a9366db68e9e5a47ba78e276bc1a8ad579db22da793cdd31efe3b85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddbacc2d0fc000c6ecfa098a355938d71c414390f687667b5ef60231888677c1"
    sha256 cellar: :any_skip_relocation, ventura:        "724e955128459f0fd22e771806e443b6134eb4ed398d494629cd1aed3b3d1826"
    sha256 cellar: :any_skip_relocation, monterey:       "9d13aa4e87b2cddfb594985cd1e2715b4473164c1b8eb97d225d7eee27add4db"
    sha256 cellar: :any_skip_relocation, big_sur:        "c880ce5b64e8b977103590da83266ef87683f915f624115adaf3fbb99dd1f1e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90a7cc0264f5ae1a5de8b30e79000059ef21ed12df24bdd758b75c487a677d19"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
    depends_on "systemd"
  end

  def install
    # Fix for error: cannot find derive macro `Deserialize` in this scope.
    # Can remove if backported to 1.13.x or when 1.14.x has a stable release.
    # Ref: https://github.com/solana-labs/solana/commit/12e24a90a009d7b8ab1ed5bb5bd42e36a4927deb
    inreplace "net-shaper/Cargo.toml", /^serde = ("[\d.]+")$/, "serde = { version = \\1, features = [\"derive\"] }"

    %w[
      cli
      bench-streamer
      faucet
      keygen
      log-analyzer
      net-shaper
      stake-accounts
      sys-tuner
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