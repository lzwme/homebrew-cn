class Antidote < Formula
  desc "Plugin manager for zsh, inspired by antigen and antibody"
  homepage "https://getantidote.github.io/"
  url "https://ghproxy.com/https://github.com/mattmc3/antidote/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "10efff67c6f243cfff965ba98dbedef350434a8cd0e5b8b4c4ee22da8ac6ef30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1aaa9b11e403260c13463770df1bf87621166f8b611aef53b1ab93ef27c06fdb"
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