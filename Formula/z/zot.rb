class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.51.tar.gz"
  sha256 "c0879bfd6fe9999e4ff5896cc240e48b67a8a6ede3c7aaf81b112fdadd22c06e"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c53da750c4fa8d888cacc2de0a8e33ebb26f6ddce98d057d640c794bfeea06b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c53da750c4fa8d888cacc2de0a8e33ebb26f6ddce98d057d640c794bfeea06b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c53da750c4fa8d888cacc2de0a8e33ebb26f6ddce98d057d640c794bfeea06b"
    sha256 cellar: :any_skip_relocation, sonoma:        "195d3ab392ba77ccbc64ae42b594b9d875bb0b432a78de9979fed8fe07d04e31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f1a0fc20df9c427d17cef976562fe82a0801442d865dacc614eb3948fc3fae7"
    sha256 cellar: :any,                 x86_64_linux:  "ff8446c7356836873e59c8218c675e27d8cc50a044f1bcedddc69e253c79640c"
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