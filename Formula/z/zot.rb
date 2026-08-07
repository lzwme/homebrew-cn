class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.35.tar.gz"
  sha256 "04f84f784f3834699571b0143c63b88b71ed12c016a75c18fc37ab10f614c636"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fe9d4b9746783a1ca2ec12d5d3114114fca570a86d7a329feaa502b2aa33413"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fe9d4b9746783a1ca2ec12d5d3114114fca570a86d7a329feaa502b2aa33413"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fe9d4b9746783a1ca2ec12d5d3114114fca570a86d7a329feaa502b2aa33413"
    sha256 cellar: :any_skip_relocation, sonoma:        "37232c2384d1f97a16fe4d9555cf89d0a6ea04843c10ea74ceb352753db2deb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09c556e63595d1a516c980fe3c6c54f6e41bf3d2a90cfffeb8763193efd921d0"
    sha256 cellar: :any,                 x86_64_linux:  "231f04b0e621547ae1c42d9696b9295b3b6e9812ced0e35c56679ec13425fbab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end