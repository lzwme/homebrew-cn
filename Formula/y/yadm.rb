class Yadm < Formula
  desc "Yet Another Dotfiles Manager"
  homepage "https:yadm.io"
  url "https:github.comTheLocehiliosanyadmarchiverefstags3.2.2.tar.gz"
  sha256 "c5fb508748995ce4c08a21d8bcda686ad680116ccf00a5318bbccf147f4c33ad"
  license "GPL-3.0-or-later"
  head "https:github.comTheLocehiliosanyadm.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "3a6b4ce5923f10c490affc90e19372b2393d40aa1ab188a71627bb3005b5ec8a"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "completionbashyadm"
    fish_completion.install "completionfishyadm.fish"
    zsh_completion.install "completionzsh_yadm"
  end

  test do
    system bin"yadm", "init"
    assert_predicate testpath".localshareyadmrepo.gitconfig", :exist?, "Failed to init repository."
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