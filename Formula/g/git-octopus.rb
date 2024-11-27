class GitOctopus < Formula
  desc "Continuous merge workflow"
  homepage "https:github.comlesfuretsgit-octopus"
  url "https:github.comlesfuretsgit-octopusarchiverefstagsv1.4.tar.gz"
  sha256 "e2800eea829c6fc74da0d3f3fcb3f7d328d1ac8fbb7b2eca8c651c0c903a50c3"
  license "LGPL-3.0-only"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "7ab7be1a2f2ae60aeaf6a8887b4d7c444e282a9d55d82ce974932279b2569c25"
  end

  def install
    system "make", "build"
    bin.install "bingit-octopus", "bingit-conflict", "bingit-apply-conflict-resolution"
    man1.install "docgit-octopus.1", "docgit-conflict.1"
  end

  test do
    (testpath".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    touch "homebrew"
    system "git", "add", "."
    system "git", "commit", "--message", "brewing"

    assert_empty shell_output("#{bin}git-octopus 2>&1").strip
  end
end