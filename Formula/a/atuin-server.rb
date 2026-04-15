class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.14.1/source.tar.gz"
  sha256 "2ac3cb8d290ab8dae4de4037417b99008404653bca462a5e45b8b648391a99d1"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4dd034a63384250151dbc9261bea71ecc9d3b4b138e5e7341216085e8aa2bb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53ff1522d1e03e961a6e32625d502a2dcf0e28066490c11b6dd550147b547ab8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8bd38e5753257b30e4c879223b6a616cdee513d9fbefe059454fe6263394364"
    sha256 cellar: :any_skip_relocation, sonoma:        "e800a4d7ae23777ab3db227c76841334808f5e1989082c484aaee548320ab3f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e9b0a2219c0a569910db5a56386b3601895edf38850423c29e2ce03ef9e47d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de734b4b072c4312874204ed84295351e848aea1efa24f79f66f249bbaa9e4a0"
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