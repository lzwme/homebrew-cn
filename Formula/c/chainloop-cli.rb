class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.89.8.tar.gz"
  sha256 "873170069e5d79750f1cf23dc1c141623ef65d2ea99ad1fdc858a1e6e4655d20"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ef7554c8eb5b425bbe338597ba44fe2d8620d684d9726086afedc8ec123d335"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46159ccfbcd11312a2600a88b83d2cd9805d43c763825e9ecfa31bf6ecf80e08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "809e1b84972b3e31bee1500a3ba8cd3a1d495cb648842b2d41208f616008eb1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c0eda5356eb3ab3f3d3908c9990506f82041ada9ee3932f53c61365e4962a53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc6140e63026a7fde9407485a8a81870aa567d2a1964ec8bbdb49a92a567c595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5a703e83707b59e88701f16682d10fc41e24c6aa4696d4f96504b74c4eaa475"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end