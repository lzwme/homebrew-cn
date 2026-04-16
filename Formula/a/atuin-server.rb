class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.15.0/source.tar.gz"
  sha256 "820324ae57462acd0e7901e138a2e5815bbc1f0a393a1e5458e1144ceae6c090"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "073c8989419a7927f7c4600738b500db0ceade7fd13c6cbdadcdcc1e4ecb9c66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "030ea2e135f0acf385d1b742fd283fb8680bc726c39f724887b4d1711c655732"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd9af66c736bafaffca379b199cf61fd4ca17f54fd5e9a45a39b579457e43cee"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3c2129f7b59b6d5bacc775b05bc920f30ebbf2bc378f6f64cceda6138df2b0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8879299f65cda6faedc2da293a723656ad1c1adf5e3f9cce7c218cc3cd79a765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "238e0b0b2b50fa8193cd8b777e9fce2a187858419d3a18c1044a9c42fdaf5d04"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

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