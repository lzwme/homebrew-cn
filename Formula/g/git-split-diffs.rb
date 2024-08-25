class GitSplitDiffs < Formula
  desc "Syntax highlighted side-by-side diffs in your terminal"
  homepage "https:github.combangagit-split-diffs"
  url "https:registry.npmjs.orggit-split-diffs-git-split-diffs-2.1.0.tgz"
  sha256 "4d49a8d4fd4e674ecd639cd9057cd3e04a503af5322b61c62b82a8221fc60729"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "f559a54e0dc235620aba00b442ab45d6b750ec24bf1570ac257fadc850a0323a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    (testpath"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "-m", "Initial commit"
    (testpath"test").delete
    (testpath"test").write "bar"
    system "git", "add", "test"
    system "git", "commit", "-m", "Second commit"

    system "git", "config", "--global", "core.pager", "git-split-diffs --color | less -RFX"

    assert_match "bar", shell_output("git diff HEAD^1...HEAD")
  end
end