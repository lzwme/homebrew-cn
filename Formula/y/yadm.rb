class Yadm < Formula
  desc "Yet Another Dotfiles Manager"
  homepage "https:yadm.io"
  url "https:github.comyadm-devyadmarchiverefstags3.3.0.tar.gz"
  sha256 "a977836ee874fece3d69b5a8f7436e6ce4e6bf8d2520f8517c128281cc6b101d"
  license "GPL-3.0-or-later"
  head "https:github.comyadm-devyadm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d86d417aca8da9b28d8979c52813d33d24073798b27600cad823c47c7dd9cd26"
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