class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "bc2d7bcbf84e761c170a3b23ff0d2917279ec2eafbe96ef360e8ca4624b769f9"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1512b017713c420b231a93b385e6bc6d7c46c05cfe486832d3d9bab9e5e9f05d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1512b017713c420b231a93b385e6bc6d7c46c05cfe486832d3d9bab9e5e9f05d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1512b017713c420b231a93b385e6bc6d7c46c05cfe486832d3d9bab9e5e9f05d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8872c7b307a6b3f1d386c4dabf36513180d9f6c3222fd36a0c69178d4043a09a"
    sha256 cellar: :any,                 x86_64_linux:      "6df38020468a7514f4151dacdf889dda6253502020f4dec1d033a029fc16b83a"
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