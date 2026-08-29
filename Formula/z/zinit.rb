class Zinit < Formula
  desc "Flexible and fast Zsh plugin manager"
  homepage "https://zdharma-continuum.github.io/zinit/wiki/"
  url "https://ghfast.top/https://github.com/zdharma-continuum/zinit/archive/refs/tags/v3.15.3.tar.gz"
  sha256 "dfd20af496fba42803c9e50a46cd5de51c7a898e0ddb26cf6fdb56f0dd6ed35f"
  license "MIT"
  head "https://github.com/zdharma-continuum/zinit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f2cb917ce0fa2c543d84440b21c031298b50ae768b273a5c51a2147c5eb219c4"
  end

  uses_from_macos "zsh"

  allow_network_access! :test

  def install
    prefix.install Dir["*"]
    man1.install_symlink prefix/"doc/zinit.1"
  end

  def caveats
    <<~EOS
      To activate zinit, add the following to your ~/.zshrc:
        source #{opt_prefix}/zinit.zsh
    EOS
  end

  test do
    system "zsh", "-c", "source #{opt_prefix}/zinit.zsh && zinit load zsh-users/zsh-autosuggestions"
  end
end