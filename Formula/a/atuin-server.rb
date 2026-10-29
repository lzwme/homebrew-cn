class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.24.3/source.tar.gz"
  sha256 "e132fedfe6ca8096f04a85887b93b029f2a2edbe1690bc713d02d9b8c846834d"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d2cbccefbe2194f07581a9fa98358fca46fd27ae92556a6566625ee67f61a524"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "981fc9535b3813d2bba382970cf65e2270ab54c8ea16cc2f071f88699fa114b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "876289ebee5c893a7efea3c9be2a1fa1eb61a7e385911439d7fb911128eeca2a"
    sha256 cellar: :any,                 arm64_linux:       "a7393e342d1eda3508243f69568bdb2207077dc5c88dda1aeb7aca56b8ff2d2a"
    sha256 cellar: :any,                 x86_64_linux:      "a0a632c37aa284bff26b1fb392e0b501c5f5d19e05b77d00c4656fd544144631"
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