class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.26.tar.gz"
  sha256 "cfbacccd329094f776cbbd12381f05f4f7afec8eef1f27be888a79c4770ea75a"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2924000fd3c94730bee50516c5ec66263a1e3e2f5ba95c4fe06780d588cdee52"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2924000fd3c94730bee50516c5ec66263a1e3e2f5ba95c4fe06780d588cdee52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2924000fd3c94730bee50516c5ec66263a1e3e2f5ba95c4fe06780d588cdee52"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a157cdf2e9de87152b01f633907063575b27570da8e416acf4e58d5465cb8395"
    sha256 cellar: :any,                 x86_64_linux:      "415d2867aa2ea132fc81a3659c6b155ba87bfe2fcd3347036ab8810d49fb0f23"
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