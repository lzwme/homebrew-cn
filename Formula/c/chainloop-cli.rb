class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.140.0.tar.gz"
  sha256 "2195d161d9334fec17d139a917e33d08904bf971c5f97a69cc3ce38e4ada252b"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d530f96cb6b0c77b7ac031bb73790acdd393edaa547abb826f080e31f111fa05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d530f96cb6b0c77b7ac031bb73790acdd393edaa547abb826f080e31f111fa05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d530f96cb6b0c77b7ac031bb73790acdd393edaa547abb826f080e31f111fa05"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c52b5c665601fd9123aa11a5a5bcbfa305fed0f14b413f6600d3dbb56fb8fb5"
    sha256 cellar: :any_skip_relocation, ventura:       "2032751c61d76d562341aa003c228e3e0378761c4ef4e3fb8418b1b3f5c1b3d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "695038575b32e1bf7710e2d0ddd3fcbf6459f033dec63aa6d38991333f905f88"
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