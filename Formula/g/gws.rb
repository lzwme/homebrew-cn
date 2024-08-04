class Gws < Formula
  desc "Manage workspaces composed of git repositories"
  homepage "https:streakycobra.github.iogws"
  url "https:github.comStreakyCobragwsarchiverefstags0.2.0.tar.gz"
  sha256 "f92b7693179c2522c57edd578abdb90b08f6e2075ed27abd4af56c1283deab1a"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "0d31f65a9ff26f5e0d80055636889fe835445ffcdcccb144333e042ae2b771aa"
  end

  depends_on "bash"

  def install
    bin.install "srcgws"

    bash_completion.install "completionsbash"
    zsh_completion.install "completionszsh"
  end

  test do
    system "git", "init", "project"
    system bin"gws", "init"
    output = shell_output("#{bin}gws status")
    assert_equal "project:\n  *                           Clean [Local only repository]\n", output
  end
end