class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.23.0/source.tar.gz"
  sha256 "64b4b9b0f84ef34bcfa88e992d38cc0b95d3cf1f6d470bb695d3ef0231445b26"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "740304375a97cc50f12c95b5775ce1b5ceda44d62f4bca8297ace69e24aa1d70"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6cfda78404e0ff42c312745b37e5d94a1c56b5087f739da0138bb097c85087f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f38f477450693215c9c6656ba4c2177235faa13698ac2029acf5a47303b45b1f"
    sha256 cellar: :any,                 arm64_linux:       "5bc61c272251aadc929ba4c3ce03239a5f50aa6f816a95938542fca532c95ee2"
    sha256 cellar: :any,                 x86_64_linux:      "a8e7f16af81e916e5ae481daebdb08b8c49da508b934e9f3828dccce42531be1"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell",
                                                      shells: [:bash, :zsh, :fish, :pwsh])
  end

  service do
    run [opt_bin/"atuin", "daemon", "start"]
    keep_alive true
    log_path var/"log/atuin.log"
    error_log_path var/"log/atuin.log"
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("#{bin}/atuin init zsh")
    assert shell_output("#{bin}/atuin history list").blank?
  end
end