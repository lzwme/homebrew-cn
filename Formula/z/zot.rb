class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.65.tar.gz"
  sha256 "e3cbb4d95a361831aac6488267e454b709efd71860deae390c34e7f8532f2cac"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cafae0d800217a9a27b7e13e05391116b942e1e3cf62eca0b35eea55f5aa9a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cafae0d800217a9a27b7e13e05391116b942e1e3cf62eca0b35eea55f5aa9a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cafae0d800217a9a27b7e13e05391116b942e1e3cf62eca0b35eea55f5aa9a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d18ef1fca42e000b4e330f1402130ec87461f939dbaeb6f554c95779765e8222"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dc48ac8600d5cb17a0471a3b6cf42ce9a153d288a871d0befd6a56b393ed2b6"
    sha256 cellar: :any,                 x86_64_linux:  "5c807a9859084fc9e511f61c4adfa9e6151b46ddea0b4b1c735e6a023a472060"
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