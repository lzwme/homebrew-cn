class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.89.7.tar.gz"
  sha256 "73042828d60aa2ba01c66cd7a3e793fc89b88328b9b7d6efdadbc5412c40605e"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29b8d306c945ce6efc511cefb30c9d3efc3830173a21f7dd15c28e8ab200fe9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "501d7d470bc1f498be28c24e68b33f066fa209dff274e2dbf6844876a0a82607"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cada12bd9a668adf3ae7c0f39a496635b0133ca9faa585734b5b89a70f2385e"
    sha256 cellar: :any_skip_relocation, sonoma:        "34858c61da8adcce509844b56ef887d03bca5b0dfaa9ece560cec39dcb82e045"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71e79ee8c957b5258407f8e53d29e7d9bdb83ce4bcc313a914ed09cdcd44bb2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee943e2f1a3a4913f904957e3fab38a82b2e42a711b9fef05098ee00c7a42d18"
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