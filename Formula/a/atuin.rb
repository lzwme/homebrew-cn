class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.13.5/source.tar.gz"
  sha256 "a3d40446b43806461cd2e15d88cc0e6fe06cf6219de01db4db1c0f4de0150477"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c1ff8ba4d4d9cca130f68ceaea0a65ebdde19fa64a691edcff0b3c73370805f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3afc2bedb403a13fc170a81b93d47fce5a86fcd446fad460c29b7b1a43a5b15a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39475af406dffa105d79dde4be96ed499aa85297fad8ed9516021bb9d8a1900f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a67fabfe120d816c78e91868da5be180befc057450409d04b0d6edd56bbb930"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e56af385833e58b4b3fa3f33b936c78c6ebcb209f33cab146c90459a96b61ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1805f23cd92612ef7d38daa87f4ef3cb260c43151ec681ea3175819554a8d0c0"
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