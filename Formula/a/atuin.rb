class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.18.0/source.tar.gz"
  sha256 "6af41dd61846a8b641b5f4736e85d1e3b55aacc2cb2709bac5bce5aff7aa7d76"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0742a86fff1ac4bec312938ac1b8be7011cf74bd270f9fbc341de60ed26e0b98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd9de778918de648980388b2a4888477437f8d6b0d8287c902b7e1778d7da299"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1035ea1dba401a61a8be27f782e5289d92eeb6e8b563a1734da562c9002259c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd3a88aba32d30fc9d8f36f68f79ec7f5cb6a3bf26bf46a7c95aa4e89693fe87"
    sha256 cellar: :any,                 arm64_linux:   "44008f924c38b66168b9b915fb0666e2634ee589077235080b4c44f1119d8553"
    sha256 cellar: :any,                 x86_64_linux:  "aadaad9fe0dfcabeefeb1ebc550604f6f3cea76b4363bfe2edaaf7f32136e769"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

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