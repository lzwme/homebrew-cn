class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.54.tar.gz"
  sha256 "0926523b701d734285a905c104a9f2802e4124b02a0e5b0ddcb56fc9565ba0fb"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8340de0e8bd8b0ee3f6a41b24e03c35b263ae6ca95da8b7de57b5addf1c52049"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8340de0e8bd8b0ee3f6a41b24e03c35b263ae6ca95da8b7de57b5addf1c52049"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8340de0e8bd8b0ee3f6a41b24e03c35b263ae6ca95da8b7de57b5addf1c52049"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e3652096c8eaa9d1f75c50a015bfe4f37592a345114a4b1037e039c236fa20d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98f6e883b66510658992b8fbf2e8c1c2114cc81babd95229cc7f3c6af02ebf07"
    sha256 cellar: :any,                 x86_64_linux:  "c779bc10ce8d1eb46aa41e418c7591879c051dcfc9c9ab9268cb571d5f43ef52"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end