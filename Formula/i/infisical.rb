class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.85.tar.gz"
  sha256 "2d8480fd43aa8656bc1318dbcf110937403ab51ae356552f592bde7992ea40d8"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5d2c3d3adf2afaca946df1600c47fc0d3de4c9f4295eeab29ba44165eec3017"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5d2c3d3adf2afaca946df1600c47fc0d3de4c9f4295eeab29ba44165eec3017"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5d2c3d3adf2afaca946df1600c47fc0d3de4c9f4295eeab29ba44165eec3017"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb039dc93330854a961496054cb13410b3d6ebb6a1aef8be262249a38811bce0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "934a6f7b233a9b8e08bc6d1a76140153e460d89446004b5a96905f025eb0200d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "022242df53d244042f4a71efc3bd1958087477a30cb68e778f1dd1731d7f23b1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end