class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.40.tar.gz"
  sha256 "ddd3db8948f957e9ed7d0136f726cffc789578fa12f739fe865e120d06198f0e"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0b05dc46efe01642e4c3ae83f422374ea47bb1ba5993867beafd2618fb1c83c7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0b05dc46efe01642e4c3ae83f422374ea47bb1ba5993867beafd2618fb1c83c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b05dc46efe01642e4c3ae83f422374ea47bb1ba5993867beafd2618fb1c83c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a331d942c504781e1df5b3ac99706d0c1af28935eb2d1eb791c0568a3fdc8345"
    sha256 cellar: :any,                 x86_64_linux:      "2ef6e8b250003541d29bf50d96f65683764f96a5ec0006077bfa5cd5c4ffd311"
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