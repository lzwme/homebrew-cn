class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.75.tar.gz"
  sha256 "6ca0a94d843d5f541fac5ac4a7fcb7b5f229ddc83a4177967d42c4a7427e2196"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aeb3123ea075263877bebd76379ab5f3fb63e2df0280fdeefdfa4d07e74b2ef2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aeb3123ea075263877bebd76379ab5f3fb63e2df0280fdeefdfa4d07e74b2ef2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aeb3123ea075263877bebd76379ab5f3fb63e2df0280fdeefdfa4d07e74b2ef2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5fb4dd0e7b55306b573651f39c0b638486d4cfe43a6e4c078306dd8831bc6be8"
    sha256 cellar: :any,                 x86_64_linux:      "2c4c9e0af7854fced1eba9dc11a6359dbf96cb6f3359067d4cb7b7b4623b33d2"
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