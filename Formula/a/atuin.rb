class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/archive/refs/tags/v18.7.1.tar.gz"
  sha256 "8a3e9e80390a996688590e27c245d5ad5dccfc2a1aedd53bd1e50e24a776e8d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33cb87eb764426649ec229f17d553ede55785acb573bd96f6a6e8ed90b350643"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6c098366627a94020870a808893138c9c303d759e8facdd27fa915ae20c88cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29b6a31b8c8419e3c38faaea2adbf2b22884e50cfd51264a4608d854aca8e2d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9b821ec481dcf76f1d32c82002964bcfb64b5b685dddffa671754f060d84224"
    sha256 cellar: :any_skip_relocation, ventura:       "5b86ba9a9aa4fffc55f8d67b80f7fee1deab417ee8951723a38a6faabd85f7e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "367ce0c1321338ce6ea4654ef524387595a2012a98c223a30023688ff0249893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd8768a279baa3ca00fd39f29c1769b05e8b2533115e844ec025b3f61162abee"
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