class Antidote < Formula
  desc "Plugin manager for zsh, inspired by antigen and antibody"
  homepage "https:getantidote.github.io"
  url "https:github.commattmc3antidotearchiverefstagsv1.9.5.tar.gz"
  sha256 "d2ad0e2a42bb17c247fd2e5649b2fa43487b60a5a413acefb231bd99a0466143"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aa21b234a499e2585ecde19f654285ba4594f13cfbcebb8295fdf914e3cec73e"
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