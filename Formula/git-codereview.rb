class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://ghproxy.com/https://github.com/golang/review/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "0d08e37d4b3219d02516e404635ad7e031ce5542cdd1f5fc7a41c83597dc3224"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e9df545884adb59839c6a2904a45d7554d870463921259616f7008cdfb86bf4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e9df545884adb59839c6a2904a45d7554d870463921259616f7008cdfb86bf4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e9df545884adb59839c6a2904a45d7554d870463921259616f7008cdfb86bf4"
    sha256 cellar: :any_skip_relocation, ventura:        "370b34d554e292af4724255815c434eb4f24d68345f59a04d73e896ecdba32f0"
    sha256 cellar: :any_skip_relocation, monterey:       "370b34d554e292af4724255815c434eb4f24d68345f59a04d73e896ecdba32f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "370b34d554e292af4724255815c434eb4f24d68345f59a04d73e896ecdba32f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f528df9c2722b1ad27872fe6bf1204c6d2e88d21c903447f13f4488587ed79c"
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