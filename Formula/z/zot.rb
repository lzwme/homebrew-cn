class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "7461774c15faa902395025c05e1c1e544b84c8e8a5fc8ead2e5da1e8faec9abe"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e4c39f169e8060f9d663ac798801cfa9d9381851c59b292e6a8573ecd668441"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e4c39f169e8060f9d663ac798801cfa9d9381851c59b292e6a8573ecd668441"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e4c39f169e8060f9d663ac798801cfa9d9381851c59b292e6a8573ecd668441"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ee35743b6d4a89fc6b10ed7c5bee23025f0ab282a0c4dbe7cb12c799f3d3e1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "985c2d848fe5952e9aeb64d889bd75a51cdd9262766e332aefab4ba0fcb9b367"
    sha256 cellar: :any,                 x86_64_linux:  "a5371c203ac9953fae7116ebc3ab7a03aeeddc396a91b46ece732f753d5630ab"
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