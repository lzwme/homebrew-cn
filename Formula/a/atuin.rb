class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.24.0/source.tar.gz"
  sha256 "ea0509b52f41b4accba22890ed04279f230cea4f2816395f4a7a30c08b51d3ce"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "39bc65e062faeab83a88d4a3b26b75e8f8bbe3454c9fb235a066685881d76fee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "38137d469e103ab9c0fccf486513ccb5d6198770a2a7b0256e0bf33a4827151f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a9c682b0299c2a01a63e117371b565689f7b5807fd3776689be876a63dd22e22"
    sha256 cellar: :any,                 arm64_linux:       "349022d08e8f757adf86ac15ed9e9d977e0c2f3c6caf40d8207919daca296140"
    sha256 cellar: :any,                 x86_64_linux:      "5fa0e7a851b8e39f3cf1663e274cad8b7caee89f3caa2159cec6c0982bf8762c"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
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