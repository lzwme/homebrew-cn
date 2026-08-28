class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.52.tar.gz"
  sha256 "8ee36fff352c5636edcd607ebdeaa4b731a58259942809410f9b6efed2f663da"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f5afffdcf79775d82b0c5ba3f042ecebfd33efe0788c6ca63195a185a10ab59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f5afffdcf79775d82b0c5ba3f042ecebfd33efe0788c6ca63195a185a10ab59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f5afffdcf79775d82b0c5ba3f042ecebfd33efe0788c6ca63195a185a10ab59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b76cf4f51e3c1598409c3dad9f2f2c1611af720cfe3c91b4aafa1547232c654d"
    sha256 cellar: :any,                 x86_64_linux:  "d038e3813b4408dab7e9741b511ef510bdd1e2ec2daa30fe552de14e10a522b6"
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