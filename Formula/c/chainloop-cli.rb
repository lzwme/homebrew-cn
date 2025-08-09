class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "4274d906c46472c4b1747e1750ad6ca0a18d92a7b52780481bf44cb6a9e8b25e"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ef13e62a4532fc033fdea6dc8a2a904b0b858b9c2c82343a164553b7a665c82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55dd7d3a5f5d65d9bb1fcf93d5040e4b349d6864e9f7c498183469881d337f63"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e6325b1dd0e7e40ffc2a2eae504c203f3dcd62010f02dafccf446dccfa1f556"
    sha256 cellar: :any_skip_relocation, sonoma:        "63bd53ed071ca45aba1f38fb819939d9e8a56c8cd54432a60cb912096d3c8010"
    sha256 cellar: :any_skip_relocation, ventura:       "59ccb4ec2143f42ba74a347d79d76854bfd11868101e6ccaf1b4ed3f28a75935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc2a950e9f9d7a14f3b9922cda07b48f3427f78c3832890768a1de76120e51dd"
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