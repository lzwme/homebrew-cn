class Yadm < Formula
  desc "Yet Another Dotfiles Manager"
  homepage "https:yadm.io"
  url "https:github.comyadm-devyadmarchiverefstags3.4.0.tar.gz"
  sha256 "fb0ab375cc41a34e014fb4a34c65f12670aedc859823b943f626adff24bde95d"
  license "GPL-3.0-or-later"
  head "https:github.comyadm-devyadm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "98fc64e460827dd5a7ad790e0c1c0ca5fe99e2f392d1dd9ca7433ab0b1982da8"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "completionbashyadm"
    fish_completion.install "completionfishyadm.fish"
    zsh_completion.install "completionzsh_yadm"
  end

  test do
    system bin"yadm", "init"
    assert_path_exists testpath".localshareyadmrepo.gitconfig", "Failed to init repository."
    assert_match testpath.to_s, shell_output("#{bin}yadm gitconfig core.worktree")

    # disable auto-alt
    system bin"yadm", "config", "yadm.auto-alt", "false"
    assert_match "false", shell_output("#{bin}yadm config yadm.auto-alt")

    (testpath"testfile").write "test"
    system bin"yadm", "add", "#{testpath}testfile"

    system bin"yadm", "gitconfig", "user.email", "test@test.org"
    system bin"yadm", "gitconfig", "user.name", "Test User"

    system bin"yadm", "commit", "-m", "test commit"
    assert_match "test commit", shell_output("#{bin}yadm log --pretty=oneline 2>&1")
  end
end