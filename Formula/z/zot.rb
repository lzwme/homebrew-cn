class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.35.tar.gz"
  sha256 "9fbdfca2177c367346b4aeda8526e0663db80668db66526f691a0495624238c4"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "57e44a214e86ac482fb54a0ee492dcb6a23eacc9ef6ce75f5d7e4bc11653ce38"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "57e44a214e86ac482fb54a0ee492dcb6a23eacc9ef6ce75f5d7e4bc11653ce38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "57e44a214e86ac482fb54a0ee492dcb6a23eacc9ef6ce75f5d7e4bc11653ce38"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e4746241d95be09795575c82456ac26f37f6734d63c4e0493a4a025a5bcd5719"
    sha256 cellar: :any,                 x86_64_linux:      "c192e23a30bfe59f2ce6b544c1900a3d22f48ff4ef6abe3d97f7f004b24bf534"
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