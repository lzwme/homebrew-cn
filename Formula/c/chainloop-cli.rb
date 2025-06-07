class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv1.5.0.tar.gz"
  sha256 "d42320fbce3199e04431ac42c28541ef9c28fd71d39abde51b1bee9ee52420a7"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8388c16f85192f8945ffa6860ba9f019ff82f3570fe3bbd9aa9646c0eaedc406"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2132ed60eefc74e7d642e88bbd81d0b6c75f032042d437749ff7dfebd3c0c3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8074f652627cd750a066ceeb3d1f1f7b88e6f83b39d825395d7e4c643f060cb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cb475fd104dce020a59edd52cb1dce00680f9f8594d424a645e4db3103eff78"
    sha256 cellar: :any_skip_relocation, ventura:       "1f6af6a93136b34a0c4b18a63ea3675d49fb05f97ab6a347bdc9a5e3453db81d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77801ad628fcab6c55cbdf0a77d3b6552d6e8577db04872937d64ca6af4c2d6b"
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