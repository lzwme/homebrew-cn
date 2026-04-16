class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.15.0/source.tar.gz"
  sha256 "820324ae57462acd0e7901e138a2e5815bbc1f0a393a1e5458e1144ceae6c090"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b6fdcff18230527e5dde20548a8f6bbe9a8575c1638b5bce849bf3b601840fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca49784f35afde8cc02efa7f7ee0d463373eeeb587571732002ecdab6fe4b476"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc98f62ccaebfdbd938638fc42e7df4cb4fd469d4e3ec40bef1b5025fbefcf57"
    sha256 cellar: :any_skip_relocation, sonoma:        "53a7f5fc78b2b591d8e596aa655fc5c6bc330c428465baffeb4eff342bc67815"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4965ee922ca99a8a4e5f3bbe16bb25acc54e5c1985dac60e7e481c5c352841a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0724c5e1791c4d4ab6a21cda1710ed2b68c013f6fba12c789b4f924fac40889e"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell",
                                                      shells: [:bash, :zsh, :fish, :pwsh])
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