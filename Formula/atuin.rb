class Atuin < Formula
  desc "Improved shell history for zsh and bash"
  homepage "https://github.com/ellie/atuin"
  url "https://ghproxy.com/https://github.com/ellie/atuin/archive/refs/tags/v14.0.0.tar.gz"
  sha256 "cccff6fcd27ab12038fc4be0f8418197813306d6210512850d21d2b749c6c797"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "750301080a94140b1894751fd0f12b863ded638405fda30658399ffbb72cccff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a1aacbeba4f3862b651ba5e92f493ed65d672d2532b0099b40ae9baae69160a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "719a8bf0a2095f16c9112d68b507ba18ff8e82da3c3f49e89d44276b2e59425d"
    sha256 cellar: :any_skip_relocation, ventura:        "379565ee8afda0e21703cb6ab8760b47336e1039137a463aeba4e1be89442205"
    sha256 cellar: :any_skip_relocation, monterey:       "28d30ba6651da5d53810db904e62ae36e9d2e5fd2dbf5afe5c622c0315fa8027"
    sha256 cellar: :any_skip_relocation, big_sur:        "26d2d24aaf02c2a27d4c8b3249951010ce1e79c43afa2c7151ad6467b3a4b75e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f2a2e896c5a485e8832f9e4e581e43fe276907ed99081a5987763efb81992ee"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell")
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("#{bin}/atuin init zsh")
    assert shell_output("#{bin}/atuin history list").blank?
  end
end