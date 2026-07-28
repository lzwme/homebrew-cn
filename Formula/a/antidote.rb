class Antidote < Formula
  desc "Plugin manager for zsh, inspired by antigen and antibody"
  homepage "https://antidote.sh/"
  url "https://ghfast.top/https://github.com/mattmc3/antidote/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "f78ebfca5cfd028b650ea2d95ed22aa463ecd9a89348ab7dac6d281989b1fa83"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d922f35d76b793f71adc3632b1a0d4aeccc048a404984490aa6ad8a20f0cba6c"
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