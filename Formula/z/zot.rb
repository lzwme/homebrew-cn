class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.82.tar.gz"
  sha256 "1d3de88802cb08491a1638aeb710a78024048756c0399bed6294c41f9ca987f1"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "663101d1d70c99fb5555a80499b6a3da2a01de003a574ca38407b0902b35dffc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "663101d1d70c99fb5555a80499b6a3da2a01de003a574ca38407b0902b35dffc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "663101d1d70c99fb5555a80499b6a3da2a01de003a574ca38407b0902b35dffc"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ef4d65f9bfaa55a5940406e6d8a45493c4d5688c01aca3f6d764333daa9ee6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "797f9464d334109a8dc9f6210410fc0044834a8c9340d98490cabb35cafc67c6"
    sha256 cellar: :any,                 x86_64_linux:  "9562579c020e85947630b6eecd5d4d4e4efa38448a9516ddd4bed200c6732f3d"
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