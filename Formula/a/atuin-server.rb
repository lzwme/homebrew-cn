class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.24.0/source.tar.gz"
  sha256 "ea0509b52f41b4accba22890ed04279f230cea4f2816395f4a7a30c08b51d3ce"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "99ad507773eae8d06937e4e0c052fda211dfe2e8d4e2f1c174f3cc9db3ce776e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aa743244df21946675cf1b3aad17d8bc95e7d4550fa763ec6d3985683540f190"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ca6208fc71007901f2c3e76cf11a78220473b405b2c917dd6c450cce68a8cd48"
    sha256 cellar: :any,                 arm64_linux:       "3ea8695b2cf1ea5f510ed68404a889a881baa9d6cce4ca3b807dc70260d22d38"
    sha256 cellar: :any,                 x86_64_linux:      "458df950ade97d1aff93498ae6c154a035d4270310c10005102861e4d0f22264"
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