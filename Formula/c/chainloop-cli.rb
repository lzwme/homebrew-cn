class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.160.0.tar.gz"
  sha256 "35f68d4fd61c4fe895f9ab92463cbe8c776456492cbf8e72821cb9e648600cd8"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab122e694fed133dc7e6fe5a50df38aa0ac57614ba8cfd7aff49f899797badb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab122e694fed133dc7e6fe5a50df38aa0ac57614ba8cfd7aff49f899797badb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab122e694fed133dc7e6fe5a50df38aa0ac57614ba8cfd7aff49f899797badb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab16746461c4e023f901889b93e44fab69514b3213c24cd2f2cb43fe12ed7c58"
    sha256 cellar: :any_skip_relocation, ventura:       "ed99c7b8869005174ea48125782af1c38c129a3a0f2634485305b805514e0a87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bc087dc9cb03fb873fa1c6d759dda16029850ff556037e940348318b2a7e60b"
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