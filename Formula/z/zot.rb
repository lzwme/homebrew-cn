class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.21.tar.gz"
  sha256 "ea1de46d0785dbf3eab8a7cb7b8662b24d9be8697abb609555370e3891318e7c"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0980cb563665ff285d6ed674ba7d961e847bb742a65c97b777002714dc846142"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0980cb563665ff285d6ed674ba7d961e847bb742a65c97b777002714dc846142"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0980cb563665ff285d6ed674ba7d961e847bb742a65c97b777002714dc846142"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9fe222f29231040562e1cb81d72d3e1bf63be77e687bbc771c01d5ba0eec49f4"
    sha256 cellar: :any,                 x86_64_linux:      "3acb226c3b4248e8f91be965efd4f5f091245c44d611ccaf71bad05e75122983"
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