class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.162.0.tar.gz"
  sha256 "0b568f38de6ba7c137506cdfc3df68a3679fd14fa772a153a665563b1ca431eb"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0745c21ca8fda8e34b25dc314fb1a7ea55c55763549a1954819bcb0bab37bbfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0745c21ca8fda8e34b25dc314fb1a7ea55c55763549a1954819bcb0bab37bbfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0745c21ca8fda8e34b25dc314fb1a7ea55c55763549a1954819bcb0bab37bbfa"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f0bc07183405012a84473f02ea8be6df8a7f04190c9df233bd4501a4212af55"
    sha256 cellar: :any_skip_relocation, ventura:       "79bcfa86a5beb7125c3a5572c6035c989d0313b4a7d3acbc38d23d3c895473b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6df7a007b371f1b5510313246d6ab7797025a16f5a54373a45c90392ee0268e"
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