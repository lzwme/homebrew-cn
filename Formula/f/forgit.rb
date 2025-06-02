class Forgit < Formula
  desc "Interactive git commands in the terminal"
  homepage "https:github.comwfxrforgit"
  url "https:github.comwfxrforgitreleasesdownload25.06.0forgit-25.06.0.tar.gz"
  sha256 "13d5f7c2afe891772559a4f8e7cdbf080fc7238be8096777ce297a47ee7179a7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f8ca1a1e5ee7656d8878561a83af2513430cf2d301e99fe48836e2aa48937a33"
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