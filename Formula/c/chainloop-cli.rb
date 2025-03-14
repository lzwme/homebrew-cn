class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.180.0.tar.gz"
  sha256 "a633417fe5766aefd810935e4461df1c7fae09bba1afa1a7f133af13f644c544"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43347ba18c4653a012692c1f99575ef496e801a55de29d28d1bedc9fb5ca62cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43347ba18c4653a012692c1f99575ef496e801a55de29d28d1bedc9fb5ca62cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43347ba18c4653a012692c1f99575ef496e801a55de29d28d1bedc9fb5ca62cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2d183414aa1dab3ac6f1f193d3e455168166a3d10f80f76d9cd34af7f652c30"
    sha256 cellar: :any_skip_relocation, ventura:       "1edb20729a227e5c65e3e9663c7abd930ad721284c597e0c96f43a2577888d16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b723eb700c1330ad205576cb203faf526d8b751d959f6923c8585cfc06e6879a"
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