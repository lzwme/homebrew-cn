class GitReview < Formula
  desc "Submit git branches to gerrit for review"
  homepage "https://opendev.org/opendev/git-review"
  url "https://files.pythonhosted.org/packages/8e/5c/18f534e16b193be36d140939b79a8046e07f343b426054c084b12d59cf0b/git-review-2.3.1.tar.gz"
  sha256 "24e938136eecb6e6cbb38b5e2b034a286b70b5bb8b5a2853585c9ed23636014f"
  license "Apache-2.0"
  revision 3
  head "https://opendev.org/opendev/git-review.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e3e07cd3081c724acabed1b87c5de98195cdcfed701cd8e2d5a9b123a4005ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "119c392a0f881ef5fa797fa5c068fa7d1668281cb129e137a2140fa61e0ec9f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a4819494bbd02ec9588319c9233531d0bcd81c455464d4449b881094f58ac7b"
    sha256 cellar: :any_skip_relocation, sonoma:         "02183437c33b30c51c5471091830a09958f590670009bb1940adf9ae09a72a23"
    sha256 cellar: :any_skip_relocation, ventura:        "151d000730015c13a9922a4467687b146febf6ae1412a0ae478ac85e53bb72e7"
    sha256 cellar: :any_skip_relocation, monterey:       "79912fd48bd1c9ebcb6e080a2118bf8841bea906d6b8167be6f8e29a7d987a9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc4c21a96afbd8a772fe47cb80f9c1b60e623fab18a152bd0e2a0aef9d5fbf55"
  end

  depends_on "python-requests"
  depends_on "python-setuptools"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "git", "remote", "add", "gerrit", "https://github.com/Homebrew/brew.sh"
    (testpath/".git/hooks/commit-msg").write "# empty - make git-review happy"
    (testpath/"foo").write "test file"
    system "git", "add", "foo"
    system "git", "commit", "-m", "test"
    system "#{bin}/git-review", "--dry-run"
  end
end