class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.99.tar.gz"
  sha256 "f1e233e1061254fbe05d40edeb92c60aa0a885006187f1deac5f01861551d0fc"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "856c75f6888eecf4e9d10cfca6defe39db3f8d36bc1c15798d9fc9603a64c079"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "856c75f6888eecf4e9d10cfca6defe39db3f8d36bc1c15798d9fc9603a64c079"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "856c75f6888eecf4e9d10cfca6defe39db3f8d36bc1c15798d9fc9603a64c079"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a3ad674035cd71effd18fb321a49f0769038f42d15b8a8d21add0195f23c121"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0a1d0e97149caaa26049e406facc1b7e3ea918207f3949a605f70ad1d3e4ff3"
    sha256 cellar: :any,                 x86_64_linux:  "2bc12c4905782d4ff3404ac0582b3f582731374445d8002d2531c2ecd13cb6c0"
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