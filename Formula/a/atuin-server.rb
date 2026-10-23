class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.24.2/source.tar.gz"
  sha256 "1b52539da5d55962dc284fa10a78cf5dccc2961fd32af6812bf3d5969f632d9e"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0c967dbaa16b70a67da6ab37e97f8f42b7c3e3eaf50c492ba6f845aad75f724b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7cde2059b1f500b0d1cc06e93128055e152691ad0db67722ecb8ccdcf061636a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "632bfa1c267e86d30cc14f648cf319329862d1d8c7053100228db07fbad199cf"
    sha256 cellar: :any,                 arm64_linux:       "f4801bc1946d1135a40d6628316682560012f9ac61b7c0a4863cb42066df31ef"
    sha256 cellar: :any,                 x86_64_linux:      "5b5827bce1e5c4d357498ebdcd4aba16a3e0246bd16019fdba5d1ebfc0afc048"
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