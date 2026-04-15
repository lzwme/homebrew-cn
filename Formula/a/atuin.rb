class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.14.1/source.tar.gz"
  sha256 "2ac3cb8d290ab8dae4de4037417b99008404653bca462a5e45b8b648391a99d1"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff00701a7ab225703c669afa8dc23fbd86f817b46b6aa9ee9729a7ea1fa65799"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0a4360c5397dcd74552f94c0525d052ea565b7f7c16e0e10fb6f1ab226c1b88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "766e653045a6677686b11f85d2490ce0e695a94778de9e56f29fd4d9b0a90c47"
    sha256 cellar: :any_skip_relocation, sonoma:        "023e3e4f8e6685dd62ad75fab23254ff520f25772c7121e2dd4a1d49074d1d6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64ba987270902219e3935347b0ef3131f4f0456835e7f7869e38414aaf301347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74028f41da50ca6597c5c7c71af268ed224827872c55ff2e58b8c6e5c220a8c2"
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