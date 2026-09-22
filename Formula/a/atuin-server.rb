class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.23.0/source.tar.gz"
  sha256 "64b4b9b0f84ef34bcfa88e992d38cc0b95d3cf1f6d470bb695d3ef0231445b26"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2142a76c23fb5c7ad6c1f6303a62a41b5d89918168b26e87b942c99223ebe834"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "94fc0a2ba870caa4ee32b09e758ba22692f24df96676836b851f49133917a738"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b7b202607be0964ce6149e21c3c6aa80c617cbd7d6522b72f6760aa125598126"
    sha256 cellar: :any,                 arm64_linux:       "9e0f8cc52d701adebf898355ac2f49eee07f13623c5b2e4aed9ce5041ab86df6"
    sha256 cellar: :any,                 x86_64_linux:      "99d4313c5a7e6c2bb99f44d7ea632ee110d4644e52ac659414ed984db3470982"
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