class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.13.2/source.tar.gz"
  sha256 "2ad4961618e6ee31652acb4e97b6f05b64b60b1a1317c468e68e5b72d8a70311"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fb42c3c1bba408e63b1017bf25c0a7ee6fe8036cb656dd652b158dc50811d98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f08749c5c4f91611f121eb0fdae5ca0938fafbc89c73c4a5d42da09eb45c1a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ec88ca98e4ea6770240939d877d4308ce5d50fed34dc424d9656f17a4e19056"
    sha256 cellar: :any_skip_relocation, sonoma:        "71a2f25d674c417e7542144dfe6034b72188265adb05628ae448a78826648846"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f069f9ab7690846ebee1a437172eb559abcbe702a858b5815bffb0b6e76637d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "973e61cf08c9acbf7cdaaa122d321c0f937b9ce0feec01b4830715fe400dce44"
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