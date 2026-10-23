class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.41.tar.gz"
  sha256 "5b363a1c1c2610d2b8c909d6ac767558bf0de6905eb2f590e6ece659856f63ba"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3196e60637ef5c11fe9c94a119ffe134497d22d137727d08e179ace91689ddc4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3196e60637ef5c11fe9c94a119ffe134497d22d137727d08e179ace91689ddc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3196e60637ef5c11fe9c94a119ffe134497d22d137727d08e179ace91689ddc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b632619ca4ef87574acac1aa3d68837c149925a744ce16d3083930b26b9360b2"
    sha256 cellar: :any,                 x86_64_linux:      "36a80aed2a6e35f4db85795de1aa25c02912031d103a6069e1fdbfd3f522d8a9"
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