class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghproxy.com/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "eeb7254877ee2b1be8a63aee62bdc0d9a2f7bbf6f2abe565765f590fafeba1e8"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "890f811d8a93f7f68d809f2822c68f2b9d2569f8731fb5d1f2d815194e79286b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2586670a71053157110c0eb30bbf8659d5630a0ea715f8784345b25aeead11c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8799b548488a713f240bf1c42b0c03bd0e979371cdcc75e4ac6824833dcfb353"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5e8b9693c7df3b5a093d1ece8c539dfd6a65b3eb5da2eb0e7e1ddf728228e64"
    sha256 cellar: :any_skip_relocation, ventura:        "c36470fe6b95fa9d849261f640f64212eda106765cdcceb3446a39561b51e4a8"
    sha256 cellar: :any_skip_relocation, monterey:       "fafb078e7bd99a67e7f793dcec6ae932ae3660135712b8643688fdeefbc525e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "329a64bd5c598c4f4cd6a96f6d3fa8ee4adbf489019be225d4519ded34f47a29"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"chainloop", ldflags: ldflags), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end