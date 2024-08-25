class Forgit < Formula
  desc "Interactive git commands in the terminal"
  homepage "https:github.comwfxrforgit"
  url "https:github.comwfxrforgitreleasesdownload24.06.0forgit-24.06.0.tar.gz"
  sha256 "7beb5e5938000b966c1c2b5d17786ae53aa85fc9127e8eb5ee41aa0210b0955b"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "1bdbf7ce08e829ec7881308d2c35ac9921c6bda724c300903fcb5dc62589932f"
  end

  depends_on "fzf"

  def install
    bin.install "bingit-forgit"
    bash_completion.install "completionsgit-forgit.bash" => "git-forgit"
    zsh_completion.install "completions_git-forgit" => "_git-forgit"
    fish_completion.install "completionsgit-forgit.fish"
    inreplace "forgit.plugin.zsh", 'FORGIT="$FORGIT_INSTALL_DIR', "FORGIT=\"#{opt_prefix}"
    inreplace "conf.dforgit.plugin.fish",
              'set -x FORGIT "$FORGIT_INSTALL_DIRbingit-forgit"',
              "set -x FORGIT \"#{opt_prefix}bingit-forgit\""
    pkgshare.install "conf.dforgit.plugin.fish"
    pkgshare.install "forgit.plugin.zsh"
    pkgshare.install_symlink "forgit.plugin.zsh" => "forgit.plugin.sh"
  end

  def caveats
    <<~EOS
      A shell plugin has been installed to:
        #{opt_pkgshare}forgit.plugin.zsh
        #{opt_pkgshare}forgit.plugin.sh
        #{opt_pkgshare}forgit.plugin.fish
    EOS
  end

  test do
    system "git", "init"
    (testpath"foo").write "bar"
    system "git", "forgit", "add", "foo"
  end
end