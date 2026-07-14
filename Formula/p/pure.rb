class Pure < Formula
  desc "Pretty, minimal and fast ZSH prompt"
  homepage "https://github.com/sindresorhus/pure"
  url "https://ghfast.top/https://github.com/sindresorhus/pure/archive/refs/tags/v1.28.2.tar.gz"
  sha256 "70b89673f66d1ad7ae656ce1c68f54d06d565a835184ccb57902e11fadfde1de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2e1a568fddb11dab85155d0f0ce974ab000b878cbe54299d25404e6f9648dc49"
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