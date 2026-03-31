class Antidote < Formula
  desc "Plugin manager for zsh, inspired by antigen and antibody"
  homepage "https://antidote.sh/"
  url "https://ghfast.top/https://github.com/mattmc3/antidote/archive/refs/tags/v2.0.10.tar.gz"
  sha256 "595a0016fbc7b82289da9fa4104e7a4b2ba0cb6fbd03625f47add9fbfffd7dc9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4320fea0aa5d9c94ddc46a3fdf9c20a7a9e008f97ca5a932716f020a60ee565f"
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