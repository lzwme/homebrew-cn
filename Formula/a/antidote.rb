class Antidote < Formula
  desc "Plugin manager for zsh, inspired by antigen and antibody"
  homepage "https:getantidote.github.io"
  url "https:github.commattmc3antidotearchiverefstagsv1.9.7.tar.gz"
  sha256 "67245a39d9719251e295cbeae7b050c99eccff5b978badd1e4b61e90575a6fac"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "1b3319c82801c1955368a98bfb8167d57983760f2e5d7ce98fe0ac3495808715"
  end

  uses_from_macos "zsh"

  def install
    pkgshare.install "antidote.zsh"
    pkgshare.install "functions"
    man.install "manman1"
  end

  def caveats
    <<~EOS
      To activate antidote, add the following to your ~.zshrc:
        source #{opt_pkgshare}antidote.zsh
    EOS
  end

  test do
    (testpath".zshrc").write <<~SHELL
      export GIT_TERMINAL_PROMPT=0
      export ANTIDOTE_HOME=~.zplugins
      source #{pkgshare}antidote.zsh
    SHELL

    system "zsh", "--login", "-i", "-c", "antidote install rupaz"
    assert_equal (testpath".zsh_plugins.txt").read, "rupaz\n"
    assert_predicate testpath".zpluginshttps-COLON--SLASH--SLASH-github.com-SLASH-rupa-SLASH-zz.sh", :exist?
  end
end