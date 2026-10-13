class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.29.tar.gz"
  sha256 "f760566615016bccf76f201e8c4cef51c7fec3b8fdb1a4b5f6a9e19a4d7007f8"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3cc75f5d4cafdaddbb71d09e80a884312746d4696dd54ed573bc4c0a6d7b48b1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3cc75f5d4cafdaddbb71d09e80a884312746d4696dd54ed573bc4c0a6d7b48b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3cc75f5d4cafdaddbb71d09e80a884312746d4696dd54ed573bc4c0a6d7b48b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "52f10b34cabd3f425fcf35fc9c4947ded4d8d797a6584536911c1747146d77f5"
    sha256 cellar: :any,                 x86_64_linux:      "a4e493135e90a89ed35b3f2032a77fac6eb59028c7b9131f69744ec241b5a47c"
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