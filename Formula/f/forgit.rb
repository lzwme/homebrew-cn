class Forgit < Formula
  desc "Interactive git commands in the terminal"
  homepage "https:github.comwfxrforgit"
  url "https:github.comwfxrforgitreleasesdownload24.10.0forgit-24.10.0.tar.gz"
  sha256 "21db63cc05b04c8c92da6977857cb37b442c7877142b4749623c739f89427878"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "029809be0efd3b4a7eae8ea90781dd205d6d05f597b65dbf6b4cb4a693fd6696"
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