class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.45.2.tar.gz"
  sha256 "1cf4b843e37e40a6a4fbacab92e0e75ca9588fdd3ff65d12e5bb83980bf074fa"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baef639846a3ba4ddacfaf4f97422eed9147f8b06cf01a63e463a60c76602f1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "155e70187f95ec81e47449f3826f4942994cd098acf01cda5f3531dd444e96dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31c6fd81edbf868d510822a601f9024ad96b81dda2102287b7e969dc6ed6b7fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fa3a14332aad4418129f0e3e6bca8dcaee1005412169ea6c00422919cbd55da"
    sha256 cellar: :any_skip_relocation, ventura:       "edd11522e1158bbf1d07af89a7d9f3deb0f74dd487b293d69c7b1093affacbba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47f59388df556a8d11c983372b92ccaf5e2dd032a1ca3a1f3b72f50ef65a4e10"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end