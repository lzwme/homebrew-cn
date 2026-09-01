class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.21.0/source.tar.gz"
  sha256 "369dd1946133756e174d902008496585cfd04abe80f8e519bb57cec6c4283bd5"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "519965fa6da326bb355fec070efad9dd3ecb50cfe44d0a7aff5db4e371179cc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba3dd7fec87a762159e30e3f19813316438826027c31c3c46ab95064a0bf5038"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fec1f8cb5d820983721d731aebb4890274ec5d72e93b0e0fa44dc6292ea9fba1"
    sha256 cellar: :any,                 arm64_linux:   "db5bbbb2aebcbded6804e88670a9bdfa0cac3ce00e46c3e3cc2124a3a82bc0fe"
    sha256 cellar: :any,                 x86_64_linux:  "d511a49b7d66833976b572c9e48110c0aa4d029b4db13aa6b8a53a6e5eb203e8"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
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