class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.20.0/source.tar.gz"
  sha256 "d0a41cdf86122a3452873823c358d5c1e5e3f60a5c51d230ce887e80f0af19a6"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24427e3a5e44ce39539aa1d6a69324755db8308e1e1b0dc918868cab9f600cfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ab069d7423673e6848c4e4010734e61fc0c8c9adddb5e6b1e68fddde25a902b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ac5cf7142d33dc0919cf448f885e0984d84cfcd7d3021c10c54f9e6e90dded8"
    sha256 cellar: :any_skip_relocation, sonoma:        "30f5425f127a88bf9bdc337559aa11841e7b1e4520af07c4491937187db895e6"
    sha256 cellar: :any,                 arm64_linux:   "af5ee6274034b0afa5eaf39fa36cf9ffb2d7f0f1420e22a0cbb3eadda7e0f916"
    sha256 cellar: :any,                 x86_64_linux:  "b0d1e2d09c635aade567a2ee9a2329dccd484d73238665e59ca49ad47ace535c"
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