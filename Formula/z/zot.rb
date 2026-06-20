class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.40.tar.gz"
  sha256 "7b10f1a15ffd30c779da412deb84dac5b560a84e32b27a274d468fa36621da0c"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10ade12161d8bf9d36e0de25569ee2b6e3b152418694328eaffc3782722a7be7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10ade12161d8bf9d36e0de25569ee2b6e3b152418694328eaffc3782722a7be7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10ade12161d8bf9d36e0de25569ee2b6e3b152418694328eaffc3782722a7be7"
    sha256 cellar: :any_skip_relocation, sonoma:        "de40710f9d9cfcd8e8665d853a20ff3181b41a1a5219f909f2a54c5ed5096d59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d42f1e21cc821a2f6a904fa91cee1d6fa4eb126ae6e826ec8dd09e11e8c966c5"
    sha256 cellar: :any,                 x86_64_linux:  "7c612fa662c38258f95c850b5b92dd1fdc925c83d785cf628c996670920deba3"
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