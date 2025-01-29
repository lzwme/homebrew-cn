class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.155.0.tar.gz"
  sha256 "31ee00cd47b603786094dc1af6252580a07a4ac4aeff6ce7f6e8a6d25402d59c"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3204b13b90012c57116a4570a851bc46a1b142250fbbe1a97d57022b9c4ebb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3204b13b90012c57116a4570a851bc46a1b142250fbbe1a97d57022b9c4ebb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3204b13b90012c57116a4570a851bc46a1b142250fbbe1a97d57022b9c4ebb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b166842d16f5c55f0b7bce1d9cfc34617a83478a072172983b8d951836e406f5"
    sha256 cellar: :any_skip_relocation, ventura:       "1c8d2e83c6b0117557c1a69cb52961363e185dfd0b458171e84fbc25482fabdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f46d429a7388f68264272ec0e5b0b76b87f09b4322ddb80c6b5d3667a0b5827"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin"chainloop"), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end