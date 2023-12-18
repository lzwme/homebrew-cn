class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git"
  homepage "https:github.comarzzengit-quick-stats"
  url "https:github.comarzzengit-quick-statsarchiverefstags2.5.2.tar.gz"
  sha256 "6487bc197422d5e37841f304f245707d2640c402b0cc457536942d96713fa2b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "180e8bcae2b30a098e8297405f6613374e164dfb9b6c5bad9222a6dce226a8f8"
  end

  on_linux do
    depends_on "util-linux" # for `column`
  end

  def install
    bin.install "git-quick-stats"
    man1.install "git-quick-stats.1"
  end

  test do
    system "git", "init"
    assert_match "All branches (sorted by most recent commit)",
      shell_output("#{bin}git-quick-stats --branches-by-date")
    assert_match(^Invalid argument, shell_output("#{bin}git-quick-stats command", 1))
  end
end