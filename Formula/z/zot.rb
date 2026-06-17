class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.35.tar.gz"
  sha256 "4a9895ecdba21861e3fb9f5f3ebdd4b478ef8fa3ea449bad45ab045931ccba46"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c608d1d55fbf26967a6ba9bd3d677dfcd183f87e583ac490bd48ef4593bae89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c608d1d55fbf26967a6ba9bd3d677dfcd183f87e583ac490bd48ef4593bae89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c608d1d55fbf26967a6ba9bd3d677dfcd183f87e583ac490bd48ef4593bae89"
    sha256 cellar: :any_skip_relocation, sonoma:        "59e51b0ae9e600b90b0c972adcce16e558bc9b1e298b0d92cdc087cc2e9199f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55a38a2c334d51b1b075ea02d83927231f906f3775beacb59a3ee57d401dd43a"
    sha256 cellar: :any,                 x86_64_linux:  "73d4b5773444d1a2414f19fdfd7b17e8e1b758460d790acb22f7f41453958a0e"
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