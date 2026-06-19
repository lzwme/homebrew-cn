class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.19",
      revision: "8fd69e1e55999ac7b73c8cd43498b9cd3445b264"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec41b8303f07217fbc6aba20e3e4aa5a75a9019eb39a82e52a552d9e146d5c4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7ca32dd5d1b1b7b8b01e873894ef15369200a5697dc2619ae89e86b03725c67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdd528621827e5a4ca769ebacf2fef770407bcfdbf208163df33bbee76b84c22"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccef0bf2bb90c9215acf9e91c6aaec69c2880e887553d3b344551d62fe7ab684"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "991dfd40cd473ca05c21ce93c08d9712c5460a13b41036465a536faf7e73b978"
    sha256 cellar: :any,                 x86_64_linux:  "31b37aae935153af8ff9079ae1ec40a0bfe62b2cda0f5263a843a663911cdfc0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end