class Antidote < Formula
  desc "Plugin manager for zsh, inspired by antigen and antibody"
  homepage "https:getantidote.github.io"
  url "https:github.commattmc3antidotearchiverefstagsv1.9.4.tar.gz"
  sha256 "b6637651176c80f0defa103af1dc6d61bb99136ac014f9be79f1884dbee85e21"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a9f45508d65304bf842606bec9d2431643fdba61d226752064aa5d5d30e1b97e"
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
    (testpath".zshrc").write <<~EOS
      export GIT_TERMINAL_PROMPT=0
      export ANTIDOTE_HOME=~.zplugins
      source #{pkgshare}antidote.zsh
    EOS
    system "zsh", "--login", "-i", "-c", "antidote install rupaz"
    assert_equal (testpath".zsh_plugins.txt").read, "rupaz\n"
    assert_predicate testpath".zpluginshttps-COLON--SLASH--SLASH-github.com-SLASH-rupa-SLASH-zz.sh", :exist?
  end
end