require "languagenode"

class GitSplitDiffs < Formula
  desc "Syntax highlighted side-by-side diffs in your terminal"
  homepage "https:github.combangagit-split-diffs"
  url "https:registry.npmjs.orggit-split-diffs-git-split-diffs-2.1.0.tgz"
  sha256 "4d49a8d4fd4e674ecd639cd9057cd3e04a503af5322b61c62b82a8221fc60729"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2244f8a3edebc099c527930bb66a3af4ea97683b335be3c492f95c282c5ba1f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2244f8a3edebc099c527930bb66a3af4ea97683b335be3c492f95c282c5ba1f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2244f8a3edebc099c527930bb66a3af4ea97683b335be3c492f95c282c5ba1f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "2244f8a3edebc099c527930bb66a3af4ea97683b335be3c492f95c282c5ba1f0"
    sha256 cellar: :any_skip_relocation, ventura:        "2244f8a3edebc099c527930bb66a3af4ea97683b335be3c492f95c282c5ba1f0"
    sha256 cellar: :any_skip_relocation, monterey:       "2244f8a3edebc099c527930bb66a3af4ea97683b335be3c492f95c282c5ba1f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c72733099ccedd81772f27388700abb6d5edfd9c77b27c8ca93dcb5af68a0bb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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