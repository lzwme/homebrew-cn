class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.97.6.tar.gz"
  sha256 "fab9062352ef235fa72b3f0f653425eb73146e48e0e378ff468e5207fbd52d66"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fcb1285037cadd752173d814f122c45d46de4c8130563373e4fbab04ccb1011"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fcb1285037cadd752173d814f122c45d46de4c8130563373e4fbab04ccb1011"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1fcb1285037cadd752173d814f122c45d46de4c8130563373e4fbab04ccb1011"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e37149a0d38ce67a40a4dd17a9b6a124ba9eb2d5af25d97063dfda441ebd031"
    sha256 cellar: :any_skip_relocation, ventura:       "f3335af4b30c98fa76729120e789ca3d95545286d077671ac43cb2e5702541dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ef62232a21773bc2fe5c4c5c0aff4f3f3199bcdf721a404e09d123cb42823b9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin"chainloop"), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end