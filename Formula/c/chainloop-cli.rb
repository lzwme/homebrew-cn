class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.96.14.tar.gz"
  sha256 "c0a7fc8df81c43228a2eede6ea6d135a64d216e8fe424192a064d51f9ad004d7"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28c3e29a376607ff9ef791210a265d17f66b2eedfdd7a4f118e134cea56e7925"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28c3e29a376607ff9ef791210a265d17f66b2eedfdd7a4f118e134cea56e7925"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28c3e29a376607ff9ef791210a265d17f66b2eedfdd7a4f118e134cea56e7925"
    sha256 cellar: :any_skip_relocation, sonoma:        "213e3adc392ee690908dfc75ddd7e133ff4bc7bcf25b8148472a50455b81a0d1"
    sha256 cellar: :any_skip_relocation, ventura:       "9290756090be386397a01169a95f42512a2dc1da9bc96f250f89b9dc966d481a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0ac10cde59938b31a1e0a63e6cf656363d17b76e580a8ee265ed863b37fa079"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin"chainloop"), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end