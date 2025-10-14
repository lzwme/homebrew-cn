class Pure < Formula
  desc "Pretty, minimal and fast ZSH prompt"
  homepage "https://github.com/sindresorhus/pure"
  url "https://ghfast.top/https://github.com/sindresorhus/pure/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "9f6822357e21567eb946ad4de867bc7aea32db3fd58d1d14076604daae305608"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bedbe228db62ce677631395a78e48945f99b00f80421a686b58c9d14fc6edc2c"
  end

  depends_on "zsh" => :test
  depends_on "zsh-async"

  def install
    zsh_function.install "pure.zsh" => "prompt_pure_setup"
  end

  test do
    zsh_command = "setopt prompt_subst; autoload -U promptinit; promptinit && prompt -p pure"
    assert_match "❯", shell_output("zsh -c '#{zsh_command}'")
  end
end