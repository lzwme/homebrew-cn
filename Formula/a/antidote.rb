class Antidote < Formula
  desc "Plugin manager for zsh, inspired by antigen and antibody"
  homepage "https://antidote.sh/"
  url "https://ghfast.top/https://github.com/mattmc3/antidote/archive/refs/tags/v2.0.11.tar.gz"
  sha256 "cd16364637b8d53dabafc11a6c4d9195468c4561cc3a826f65c405c7b870e17f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9e513b2035fe4dd7edeedc9052a5e9a40b34da93d1ea1edc1ffffc9902faa7f7"
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