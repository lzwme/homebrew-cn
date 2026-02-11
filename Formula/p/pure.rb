class Pure < Formula
  desc "Pretty, minimal and fast ZSH prompt"
  homepage "https://github.com/sindresorhus/pure"
  url "https://ghfast.top/https://github.com/sindresorhus/pure/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "2d1594ba329aafd495172754c76ba8fa022b2409c9650a20c11f89edc64470dc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "15a6aa90346781485e4acf490185eee3acb57d08f4a7d053edc1b767462850e5"
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