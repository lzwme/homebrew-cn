class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.1.31.tar.gz"
  sha256 "af3d76ec9ddd1208766737d936f072fb2ead43648be385782cba86940b31a5ae"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1fc1ee6bdaea2e022850abea0d00d36c6e8407c208ac2886976717eb9bc98ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dcab52be7b26de989be1ac849122e4d32010ab5e50391c388ac332a628030c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e55517c172fd17e83b8b770f18c1f4298095df238dca729b4fab75f53c1820e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e96862a9e3a8565bc546e9e21ed37f3e695d134f3dff5994ba6d4fd96b8cc37"
    sha256 cellar: :any_skip_relocation, ventura:       "6e24ab7203d39e04935bbd5d8359729d15e860689f80e25a7894fde62c3c8073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aebdfc032ba2af55ce7e253b806fd30e6c8cb350a34e9d803983e7980a233e89"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end