class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.21.0/source.tar.gz"
  sha256 "369dd1946133756e174d902008496585cfd04abe80f8e519bb57cec6c4283bd5"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b052b7c980f1a9f59ba2e64f130a6c8e46e63291c7da220e9db05f9ea966bf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a5107b0c072ab7e96230a94475e4a47644d1284d18e558f27312a3a9a69fc96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68ebf2a9097dd45f8d5166818cab1cfe560cdb6d027c637ebc953cbb361b1d01"
    sha256 cellar: :any,                 arm64_linux:   "3b3eda4a2a10a49b151eb84cc29db2c628bcee27e69803d5688e1eb0a29c62f1"
    sha256 cellar: :any,                 x86_64_linux:  "22c346a4955215b14c33c8a2eabca9dcbb6a02bfe51f2de477948aed17590b8e"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
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