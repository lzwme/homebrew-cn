class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.57.tar.gz"
  sha256 "fe16725e5fd4ec7318ea2455736779282bbdf9b929ca9a2afc37efa39d9c9bc7"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bcc03109b03cc666add4e0b63a895013cf054cfb945a0de97def7cff24d486a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bcc03109b03cc666add4e0b63a895013cf054cfb945a0de97def7cff24d486a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bcc03109b03cc666add4e0b63a895013cf054cfb945a0de97def7cff24d486a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b58c0cbb9d783e125da93c0787ba9524a8da0d9bf71b2ee6b6858ccee6e643a9"
    sha256 cellar: :any,                 x86_64_linux:  "bd26fbbaab09df31f7471684a6bcb55a67cd57ca3cf78e15abbe4ba74cb51a5a"
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