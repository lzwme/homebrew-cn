class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.12.1/source.tar.gz"
  sha256 "94b38e6031bad2409c176beae63580da35a1c3a1c129cc7c4c8f74f1e2965638"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b91b45a76e0bac77a47e71f924f23ee840c8c520a856c4f13e6cd6f0a710a937"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "219c1f3d7660a2c59a212d65472b3e2bc4537fdba03c04efbffeff60cb93ab20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "719d5004795c9677551cfd5f89ec6e825f4717941eb382c9e3406cb1d886159c"
    sha256 cellar: :any_skip_relocation, sonoma:        "675b9c09cc3fa2921442bb263e1da5788c46913b58fae0206b5294da89db6b95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cdf861bd78efe32114c907f7a01ab88a8c52cf5c60bb8af79d82a31275361dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45611e30436438d07d9fbd3d3fbaee7208789676815fddf6f7acdd93d60ab458"
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