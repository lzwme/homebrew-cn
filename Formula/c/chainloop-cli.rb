class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.50.0.tar.gz"
  sha256 "762b47c75c71e9775316fce0bfbc18a13f4224486c9b36ea2b1812aa33dea22e"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc0744773dfe12260df5ef6acec6f43ef15df0d3129915e2cccb5ddbf8bff2b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95bd310d84b7f2710f9761420c737db434a58b05cf495beafc48393be2c08bcd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afe02dfc3702632e15f965f1a28012df43945277812c6e2a602986c3ddd1c37b"
    sha256 cellar: :any_skip_relocation, sonoma:         "de2438fa683d6b0bfbee5c933517edede0a062a87d3ff2889b485088b8f40043"
    sha256 cellar: :any_skip_relocation, ventura:        "533cdd7b3bcab70872596d4ee7f23d0a659b9e0393c10f5e2e4c24f028532663"
    sha256 cellar: :any_skip_relocation, monterey:       "7f330b99e52caeefe32be7a3a8ff06c7d5b453d902a97d1334e0970e71c8e44c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b63cb4a9b34625cc74aca4184778acee7c3eaa93cfde4c625385fb8fecf47f1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin"chainloop", ldflags: ldflags), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end