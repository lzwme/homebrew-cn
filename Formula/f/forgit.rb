class Forgit < Formula
  desc "Interactive git commands in the terminal"
  homepage "https:github.comwfxrforgit"
  url "https:github.comwfxrforgitreleasesdownload25.03.0forgit-25.03.0.tar.gz"
  sha256 "6b521c491d8c7bf4b39ab4311ae6e5864013b25acb857fd999e18847863c41a4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e4eea5d3b3924bbae5e0a8eac67d6462657ee8d4897f1d207b5deca34576bcf6"
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