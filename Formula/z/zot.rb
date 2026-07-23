class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "626cee4ff3ebe6dbd3076746ca5f5eba6e1739568f669ec9603ab39b8f16d873"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f31ea5606eebebde27952c95e95384b41b29840c69d9eb17f8edd3d7925d3c68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f31ea5606eebebde27952c95e95384b41b29840c69d9eb17f8edd3d7925d3c68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f31ea5606eebebde27952c95e95384b41b29840c69d9eb17f8edd3d7925d3c68"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff977f47a0101312445e29d905db574c4c276177d47867648735acbfb71cec3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eff36b93dae6c4ff675919d1d252b4323cf90ff2f6ab16e875a1ac934f5e8910"
    sha256 cellar: :any,                 x86_64_linux:  "7ff209f3c638884ff6a1863acbc2f5abfe36c3a4ac884e5bce188d96bc4a5732"
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