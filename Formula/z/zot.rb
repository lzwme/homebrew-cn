class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "d01b487bc7d594de5c121518339780cba86633c20e4281f447d5400fb865d7d3"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8aa7f9d18daa99b709aea15c202f3b742f8c0c812ad9bc44482bc24c439074e6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8aa7f9d18daa99b709aea15c202f3b742f8c0c812ad9bc44482bc24c439074e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8aa7f9d18daa99b709aea15c202f3b742f8c0c812ad9bc44482bc24c439074e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "62eeb9ccc9052ed1de43fc94fbf9bf8c3c1dfd002a3f212454c7e788340ae8f8"
    sha256 cellar: :any,                 x86_64_linux:      "0ea903f9281022d32f6888cd343b6b8714f62362e30122bc727da690dd2d7025"
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