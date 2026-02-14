class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.76.0.tar.gz"
  sha256 "3b7d8b6be000eb51f2cc953501681a863a5e331d125455d568923294d7c55ea2"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cecd233e22887659b862e1a3206bb695b917536f127b118e567f89a23929deb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7efed4138adcb980866f7ecd5f4fc0743e24215b8cc534adfb3fb6611c28a17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "284836ae1ed836edd8a6ea163a57bb1fed0dd6a48107b4bee4807e4360fd2222"
    sha256 cellar: :any_skip_relocation, sonoma:        "d919f1d9080f4d4d5a4031d03d4c2ba5131f3bd798fe32c6ea8e2ecd0a4af059"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f78e2b2722d2f4a78f983ccc00f6f3d715f1fa26b3d0fae73678dc634d4413e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "248612ff7a3fcad52639ba4eea3c0350a1ea1566071c0a48e852a013c0d8ab50"
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
    assert_match "run chainloop auth login", output
  end
end