class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https:pkg.go.devgolang.orgxreviewgit-codereview"
  url "https:github.comgolangreviewarchiverefstagsv1.13.0.tar.gz"
  sha256 "e67f223353f191aca75e8e2af713febd07adf596a1718a03276fbc6bab3db746"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cedfd30b6db4a1ee19104c3f2b9a1b0f0b46bd0559e6545b194e314f2b22047e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cedfd30b6db4a1ee19104c3f2b9a1b0f0b46bd0559e6545b194e314f2b22047e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cedfd30b6db4a1ee19104c3f2b9a1b0f0b46bd0559e6545b194e314f2b22047e"
    sha256 cellar: :any_skip_relocation, sonoma:        "74875343a167eb4140b98b17c75ab1f2e121f90957a00a545731542c21866d29"
    sha256 cellar: :any_skip_relocation, ventura:       "74875343a167eb4140b98b17c75ab1f2e121f90957a00a545731542c21866d29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9ededa7834b7107a2b31dd49e3e3d71411d5b2070faf0c78a3497562f68b22b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, ".git-codereview"
  end

  test do
    system "git", "init"
    system "git", "codereview", "hooks"
    assert_match "git-codereview hook-invoke", (testpath".githookscommit-msg").read
  end
end