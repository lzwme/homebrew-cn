class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.18.0/source.tar.gz"
  sha256 "6af41dd61846a8b641b5f4736e85d1e3b55aacc2cb2709bac5bce5aff7aa7d76"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "652b89465d9aeeb8f54afc59f50b694113cdcd50c815d35d0fa6b3516ab64d17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b0729112d0698900812cdd03017a434b391716cc5d24ed91f96f50eb0e2e5fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8187f0336036f676919f70affd93b864fa347e9e4332270e5829abfb9e40cbca"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd5a3749359bc1e48b2f74506d4a74f0f72f50f88808b00efedbcb4224faf559"
    sha256 cellar: :any,                 arm64_linux:   "3f44e3fc3c9c74766c3912b53ee83d3ec05203fb1417ff7a0df64b3b3ac04eb0"
    sha256 cellar: :any,                 x86_64_linux:  "e42d476901a11ee2d86c44423e4a0ba93096d1ab4ff9e22fbea91b7e744b410f"
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