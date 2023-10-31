class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://ghproxy.com/https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.3.6.tar.gz"
  sha256 "fc7201829f21c4d30957ab1b7b596d2c15885ef4ea4aa1b30ad692306af818c0"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc6615aa711f3330e9bbac82789e204e61e3e22c6344dd7955eb6296b22a560f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3491863cd5479ef1c375aca4e5c64443e916115b5bec5c0830ba9ca3227b7f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f382a60b3962176a0c864e6a37beab78ba19d55118f2164fb5d50df7423db8f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f1a830845fd6c0b347b24ba32cf4e4b5bc3717a3232c4737d17271ff3fb7db0"
    sha256 cellar: :any_skip_relocation, ventura:        "259ffcc0ac4ee3b21f095cc5647e8514378f1357c71cdcc5b5e7d453e1a81ca4"
    sha256 cellar: :any_skip_relocation, monterey:       "baaa6e960585953aa4770225a4f3d4a444f1c7402ba16d8022526d0499e42caf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6adfe7d7869394c57eb95af69b7d68528f134fe3a475311c17af896ddd982127"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/httpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end