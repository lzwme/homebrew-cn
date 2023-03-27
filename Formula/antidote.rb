class Antidote < Formula
  desc "Plugin manager for zsh, inspired by antigen and antibody"
  homepage "https://getantidote.github.io/"
  url "https://ghproxy.com/https://github.com/mattmc3/antidote/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "3c63f2810f109ec3140a69296a3905210865f04ddd934085c6c5c63e18a587f7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "29d47b8e8dbe185b6dcb06160618922de613fa105fcc6ca6362d57bcaf48abe2"
  end

  uses_from_macos "zsh"

  def install
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
    (testpath/".zshrc").write <<~EOS
      export GIT_TERMINAL_PROMPT=0
      export ANTIDOTE_HOME=~/.zplugins
      source #{pkgshare}/antidote.zsh
    EOS
    system "zsh", "--login", "-i", "-c", "antidote install rupa/z"
    assert_equal (testpath/".zsh_plugins.txt").read, "rupa/z\n"
    assert_predicate testpath/".zplugins/https-COLON--SLASH--SLASH-github.com-SLASH-rupa-SLASH-z/z.sh", :exist?
  end
end