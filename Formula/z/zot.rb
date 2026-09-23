class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.86.tar.gz"
  sha256 "cc59ab59f1ecd7eb0229b4f5a3321c86b830bd8cc85166085bdb822bc70732c1"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e92b3043ce9a8184562c1d5189abb0f32890a866afc3de6b405e32708b89b072"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e92b3043ce9a8184562c1d5189abb0f32890a866afc3de6b405e32708b89b072"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e92b3043ce9a8184562c1d5189abb0f32890a866afc3de6b405e32708b89b072"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "39cc5e265133a991ab17de98d10e21b2db4a5441eb36c4fdd3b99740d252853b"
    sha256 cellar: :any,                 x86_64_linux:      "2a5e70522c187560eb86b3f641fccc3bb7485711595816f458c4e1905c036116"
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