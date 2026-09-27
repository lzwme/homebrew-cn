class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "a651a6fcdf79ca9b0a93dc29839f5d2f1bd1f3f6727874c18352c50c8d02e9eb"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1ca820eceaf6a844751f82801bbd7e14e543d36005e5557273f574612198cebc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1ca820eceaf6a844751f82801bbd7e14e543d36005e5557273f574612198cebc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1ca820eceaf6a844751f82801bbd7e14e543d36005e5557273f574612198cebc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bf012094c7217b11abf5e6819292ad52e0d798d949c4d1243577e7a6095c530c"
    sha256 cellar: :any,                 x86_64_linux:      "5f9c90cac69cc50588c668d3556bdf6252f5dda38d00d243001fb7c8a7b8e507"
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