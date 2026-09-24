class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.23.0/source.tar.gz"
  sha256 "64b4b9b0f84ef34bcfa88e992d38cc0b95d3cf1f6d470bb695d3ef0231445b26"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2fde158fe3c5c944150834572f99ba5dde2d9242a80309dac59c469959411751"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3e115f548dd4f0928bc0ad11148a6260cd51e2892575b7f91b74b2d5d283cb82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f04f60e264439225eebf32cb51b0902c73d00633894aecf1241188704748bfa4"
    sha256 cellar: :any,                 arm64_linux:       "78ec7e09447d56df2e18b0cce34a0b6d2221a1385a0fb56de81c20b31a1d649c"
    sha256 cellar: :any,                 x86_64_linux:      "f29cdc0be3e639d24395558e31fdd1a2a991e74d123dbd78eea3dd662c28f59b"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin-server")
    pkgetc.install "crates/atuin-server/server.toml"
  end

  service do
    run [opt_bin/"atuin-server", "start"]
    environment_variables ATUIN_CONFIG_DIR: etc/"atuin-server"
    keep_alive true
    log_path var/"log/atuin-server.log"
    error_log_path var/"log/atuin-server.log"
  end

  def caveats
    <<~EOS
      The configuration file is located at:
        #{pkgetc}/server.toml
    EOS
  end

  test do
    assert_match "Atuin sync server", shell_output("#{bin}/atuin-server 2>&1", 2)
  end
end