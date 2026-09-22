class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.84.tar.gz"
  sha256 "f9335bab58cebf4a0eaa12c741fd4f34abdb0cc74563919f92441a3959e3b09c"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2a8a734f96a6392b73b55c4a4be75007bb0166abde49649923444a81a4df0706"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2a8a734f96a6392b73b55c4a4be75007bb0166abde49649923444a81a4df0706"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2a8a734f96a6392b73b55c4a4be75007bb0166abde49649923444a81a4df0706"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "065bbade3ed18e59cdc7880d896c266c401c7b10ee920f062ca5b51e2dcb1867"
    sha256 cellar: :any,                 x86_64_linux:      "0690345068138b2e0a7b9522f2375315b925082941adc7ba4970d958744e20a3"
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