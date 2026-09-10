class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.70.tar.gz"
  sha256 "ded80d749dc1d1bfe6cdcf52e964f0620c8e515988ebe4fecfc8eab23d3c0539"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb17e7712e95a165896ac4ecd7016c09c00e990e58aac368b84c70d7b6e35d85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb17e7712e95a165896ac4ecd7016c09c00e990e58aac368b84c70d7b6e35d85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb17e7712e95a165896ac4ecd7016c09c00e990e58aac368b84c70d7b6e35d85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21155f017f5340263cb7d9728a74a63899400ccd59e0907f769c4364c79edb2d"
    sha256 cellar: :any,                 x86_64_linux:  "87e49c49a829e9041305556795ca6fb566926470626f70c4a4627c98fff88493"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end