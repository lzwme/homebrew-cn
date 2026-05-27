class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.98.5.tar.gz"
  sha256 "d09c0cf2c84ea9e4e0dfefd24b885a3e3885339334ca5b028b62c64d133ce680"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ecf514378be68aaa095c02468089353ed0d74549a0fee2b7ba3090066959859"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5abd14db71434bee148ad57bbfe253d1fbd03a8ddc1e93b2f8ced56198122f25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1798f2a95cb731a2c1f8c7d3c2e7a0dcc2355372a78afc5e82892a0fa926ea8"
    sha256 cellar: :any_skip_relocation, sonoma:        "386d6fd05bb20fc1d4647d31853e8291a2086b6b4e907b32513d89ddf64a5edc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a04f78b40a767b96fdf49b105f3a34969b32faa658aaae68794f86157061ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5361cb3f2e4844d395a93fb6b96c3995608f97d932b5e40700939dd15bc90d0f"
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