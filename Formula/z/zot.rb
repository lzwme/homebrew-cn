class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.50.tar.gz"
  sha256 "5876af6a1311910ff6518aad46aa793007ded1b97ce41636c0035267536507c7"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d0db02b6b733b8bf9e27ebb3ed548c9a593365c40b1c4f4ceedccce2368318e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d0db02b6b733b8bf9e27ebb3ed548c9a593365c40b1c4f4ceedccce2368318e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d0db02b6b733b8bf9e27ebb3ed548c9a593365c40b1c4f4ceedccce2368318e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ff452fb1f9aef4f43c87623330e7b2cdee8bc6a5d701f9d653963513630e607"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d972616354135a76d6327b50dea8fc9e3b89553b3afbf729a2db782db0a8d3c"
    sha256 cellar: :any,                 x86_64_linux:  "cbdcc2a2d135f1b56d5ed561bb177b62d0e43adccae2aa7712c2a3a29c5a520f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end