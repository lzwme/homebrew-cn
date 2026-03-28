class Antidote < Formula
  desc "Plugin manager for zsh, inspired by antigen and antibody"
  homepage "https://antidote.sh/"
  url "https://ghfast.top/https://github.com/mattmc3/antidote/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "0fb64b879f323fb4a376405173ac36649ef5d20000c9053b82f4d327bd6a4e0d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "81b1632c9e8daac9d7931bb6cbdc7944db6a175f37f818d96d796c497cf5c70d"
  end

  uses_from_macos "zsh"

  def install
    pkgshare.install "antidote"
    pkgshare.install "antidote.zsh"
    pkgshare.install "functions"
    man.install "man/man1"
  end

  def caveats
    <<~EOS
      To activate antidote, add the following to your ~/.zshrc:
        source #{opt_pkgshare}/antidote.zsh
    EOS
  end

  test do
    (testpath/".zshrc").write <<~SHELL
      export GIT_TERMINAL_PROMPT=0
      export ANTIDOTE_HOME=~/.zplugins
      source #{pkgshare}/antidote.zsh
    SHELL

    system "zsh", "--login", "-i", "-c", "antidote install rupa/z"
    assert_equal (testpath/".zsh_plugins.txt").read, "rupa/z\n"
    assert_path_exists testpath/".zplugins/github.com/rupa/z/z.sh"
  end
end