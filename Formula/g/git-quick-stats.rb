class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git"
  homepage "https:github.comarzzengit-quick-stats"
  url "https:github.comarzzengit-quick-statsarchiverefstags2.5.7.tar.gz"
  sha256 "4a3c51c9f5ccb9a4e0d383fac18308b0d1366a66e1e5d3dcb25b275db5dec109"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "51f11fe95972e4dcb73abcf0e2635131835fba5e8ee52c0c27d6606826c6fda9"
  end

  on_macos do
    depends_on "coreutils"
  end

  on_linux do
    depends_on "util-linux" # for `column`
  end

  def install
    bin.install "git-quick-stats"
    man1.install "git-quick-stats.1"
  end

  test do
    ENV.prepend_path "PATH", Formula["coreutils"].libexec"gnubin" if OS.mac?

    system "git", "init", "--initial-branch=master"
    assert_match "All branches (sorted by most recent commit)",
      shell_output("#{bin}git-quick-stats --branches-by-date")
    assert_match(^Invalid argument, shell_output("#{bin}git-quick-stats command", 1))
  end
end