class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.20.1/source.tar.gz"
  sha256 "c4faccd208fe3b407e83c6943b2d81081a94fe836da9b67f1a7b4d4f4bbb0fab"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1038bc416c901a63b077c371ae140c0895ffc33759512d3546721aa0e46ec48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39c39f17b1cd1252d9dab009c8efa83ac078df4a3fa187428b325eda87362668"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e467dc05a6210b61b8eb29404c726c17013f8402c310c4f37bcf372ab75e42f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec2ad623d76d5881519969c5fc1e6290df5986d66103dc5fa331516bd415bacf"
    sha256 cellar: :any,                 arm64_linux:   "b8bd75f34e6c33d1bd727acd416327d0dba461a92793e1a27ff6255af674e0bd"
    sha256 cellar: :any,                 x86_64_linux:  "4d965783d1201bf69033ff658ef8529677cc21e2996d119a1d1b09c4025f09cb"
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