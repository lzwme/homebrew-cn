class Yadm < Formula
  desc "Yet Another Dotfiles Manager"
  homepage "https://yadm.io/"
  url "https://ghfast.top/https://github.com/yadm-dev/yadm/archive/refs/tags/3.5.0.tar.gz"
  sha256 "2a15ed91238dd2f15db9905eb56702272c079ad9c37c505dfee69c6b5e9054b6"
  license "GPL-3.0-or-later"
  head "https://github.com/yadm-dev/yadm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "323e01bb5b2d4578628cf24afdd1446f6b858927b62cc461da626339f5c053f0"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "completion/bash/yadm"
    fish_completion.install "completion/fish/yadm.fish"
    zsh_completion.install "completion/zsh/_yadm"
  end

  test do
    system bin/"yadm", "init"
    assert_path_exists testpath/".local/share/yadm/repo.git/config", "Failed to init repository."
    assert_match testpath.to_s, shell_output("#{bin}/yadm gitconfig core.worktree")

    # disable auto-alt
    system bin/"yadm", "config", "yadm.auto-alt", "false"
    assert_match "false", shell_output("#{bin}/yadm config yadm.auto-alt")

    (testpath/"testfile").write "test"
    system bin/"yadm", "add", "#{testpath}/testfile"

    system bin/"yadm", "gitconfig", "user.email", "test@test.org"
    system bin/"yadm", "gitconfig", "user.name", "Test User"

    system bin/"yadm", "commit", "-m", "test commit"
    assert_match "test commit", shell_output("#{bin}/yadm log --pretty=oneline 2>&1")
  end
end