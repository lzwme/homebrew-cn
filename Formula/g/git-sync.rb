class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync"
  url "https://ghfast.top/https://github.com/kubernetes/git-sync/archive/refs/tags/v4.4.3.tar.gz"
  sha256 "38c7dfef256d5321e57e46ea94a245aadc963e50f0e3231b3ce710095b81d7ed"
  license "Apache-2.0"
  head "https://github.com/kubernetes/git-sync.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a67e632e91a310f3acb38ec44e4547dd80a68f875d4e3731b1dd33925ded1a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a67e632e91a310f3acb38ec44e4547dd80a68f875d4e3731b1dd33925ded1a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a67e632e91a310f3acb38ec44e4547dd80a68f875d4e3731b1dd33925ded1a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "797f9c41559afbd1fc929ec59350fc2b5f12b2ec4a8a5520cf0c3f51be5b6944"
    sha256 cellar: :any_skip_relocation, ventura:       "797f9c41559afbd1fc929ec59350fc2b5f12b2ec4a8a5520cf0c3f51be5b6944"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5234e7c2e964ec0064e4c8bec973f3a64ea036b433b89739da5390ff16889283"
  end

  depends_on "go" => :build

  depends_on "coreutils"

  conflicts_with "git-extras", because: "both install `git-sync` binaries"

  def install
    ldflags = %W[
      -s -w
      -X k8s.io/git-sync/pkg/version.VERSION=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    expected_output = "Could not read from remote repository"
    assert_match expected_output, shell_output("#{bin}/#{name} --repo=127.0.0.1/x --root=/tmp/x 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/#{name} --version")
  end
end