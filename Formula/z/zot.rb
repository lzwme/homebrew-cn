class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.31.tar.gz"
  sha256 "82b4365ecfc976c11457fd813b8d7c96bd3a9bb1f6d629bf728751b12f8f021c"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eb1796029a1cdc9ce7e6e939b26a57b6d489e85d4ea9106645365b19c9dd4d93"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eb1796029a1cdc9ce7e6e939b26a57b6d489e85d4ea9106645365b19c9dd4d93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eb1796029a1cdc9ce7e6e939b26a57b6d489e85d4ea9106645365b19c9dd4d93"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7d9e1657a969bd5852795b6b9ecd567824b8a629d9810908d8804d74c1284e7e"
    sha256 cellar: :any,                 x86_64_linux:      "49b0831c5f9c0da8b33f364ca610aeb5b2cc47792282409e2cfcec376a80aac1"
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