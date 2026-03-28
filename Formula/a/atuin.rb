class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.13.6/source.tar.gz"
  sha256 "89d12e2b5b69a0cf47113a0e9c55edd297ca5393be11e616685d0b6567133acd"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0019b95cbcdfbbf7bf53e8a5e4ac64ec074ad8ed0735448a7e3872c0e48424c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "025b83c2ba4276b026efa17729af4b3ec7cebcb27748341cf7408ce0a28481cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6e1c1d5646d6dbc714158ca1f446fd8f0f5a029bd60445abcd83af8fcb11286"
    sha256 cellar: :any_skip_relocation, sonoma:        "7341500e9dc53e4dc250a57eb0e25911fff6f5542c7491a4c499ba500897ec1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b43b00ef48c99f0b376bb0a031e7f15aad83c8801aad5c66fb5974105e23d7a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef95ab52aafddc64700a525fe1deb4fc57c8a0bfd2971c0a5cbacdd929df3a8e"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell")
  end

  service do
    run [opt_bin/"atuin", "daemon"]
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