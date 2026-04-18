class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.93.3.tar.gz"
  sha256 "acec856ae9389002d643a25a95d3d6712ff762e3b759d00c94fbce69a979fd49"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3d9f2aac4a39c9f416094b790d11227e2cfc62e90330d92c261d228906ddace"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dff889f56c334a7c63e3b725552fbef61120b49a5968f3ec647e4e75f435487"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92719ccf2eb65a7ff08e30a4da366435d99c713b0f2ff57766433c576100df0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1e5994d8b155097ab3fe94b88a6a0cdfcb5f91a2e3c2d076eb2224d9b3512d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f346d0128f4874c975002d2ce57723a0e3b82cbe821acaae2ad9b887fc13139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fccd380251eb6925f3e99e89c75002dff42fcbb45338003ec207764f0e1db28d"
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