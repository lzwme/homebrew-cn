class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://ghproxy.com/https://github.com/golang/review/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "ec69d2778dd11e374fe3403c824f08284560c174ffc73aa596d8ba5f1d6ebf40"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef48696659d829aaa672f643fd0c58feb389e98c07da24029797689b0828b500"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a25e0340014811e4356e3fa7cd3ee73c82fc6b5c41f8d2175be6a0fa90879fad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c959bbc587d7f139e53e9aa57e8da7acba45ec525517c2a4192e33c7aefd292"
    sha256 cellar: :any_skip_relocation, sonoma:         "abab9fcfd64efbe626eabf40f0e1be7844aff7638179fd1beb608a0d0572385c"
    sha256 cellar: :any_skip_relocation, ventura:        "6787892fb1a5e1054f7a2359a92b3192eb699516fb3f25206753f63c6d7d6e7d"
    sha256 cellar: :any_skip_relocation, monterey:       "a2f477f8473045063bd36cbd7e410927d56b0a4df32201f4f24c1f6e888c274d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab483777dc6205676bcf7248e947140ebd985e08a58559b4ffa4d67d8ea00275"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./git-codereview"
  end

  test do
    system "git", "init"
    system "git", "codereview", "hooks"
    assert_match "git-codereview hook-invoke", (testpath/".git/hooks/commit-msg").read
  end
end