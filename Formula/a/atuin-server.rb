class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.18.1/source.tar.gz"
  sha256 "ac3505b014a019ecb8657ba974c452b0068edf0c69962e3d677c4c49e9d7fe80"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64a467987faf227338cd12b5dd8dc5047eecaec1df2ab8117d9651446b4168c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "077737304c0f6b140edfd14a4a5df0121056439eb33c7ab074e8e3898613f8e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6c58b85dde5779ee812a46cfffa67a7ca7877cb148f124c58811fefd57c975f"
    sha256 cellar: :any_skip_relocation, sonoma:        "105fad3b95245c306639c14bbbd7938d499be447321a77555696a95641ad0eca"
    sha256 cellar: :any,                 arm64_linux:   "5dbdc06faaafc5c0a5b84f861fb1cb9a338927c2d8e5efa48f6c1ebfb21a0e75"
    sha256 cellar: :any,                 x86_64_linux:  "34232c6447640064439c9d93736d462653653b195e9d654a9261b18f7b82ac7d"
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