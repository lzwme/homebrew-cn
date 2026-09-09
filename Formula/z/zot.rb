class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.69.tar.gz"
  sha256 "b857aa1c164c8aa169607d73c6d7963b1febed24c3a850156c7f9989a94d4b51"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cf10d2a6844bba1f503ea720a610bcd88898e427ae7851d6f3189907c450f62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cf10d2a6844bba1f503ea720a610bcd88898e427ae7851d6f3189907c450f62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cf10d2a6844bba1f503ea720a610bcd88898e427ae7851d6f3189907c450f62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef50a3724bb3ed32c52e66d7d8c247f8ae089f2cfcbe53c8058c2f79e6802ce4"
    sha256 cellar: :any,                 x86_64_linux:  "dce2d47eb9b4b53f66a74f2de927ff2fe1c55efaf983f87362d093aff36deacf"
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