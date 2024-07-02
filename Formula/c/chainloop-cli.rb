class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.93.1.tar.gz"
  sha256 "68ea6b30ef991f8e74a7aab726c59658176244afbb4cb10c860504af8cd3a140"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fda9554fa8f88c6c904feddc02ba79d3e60dc3a95309356964c241bb8e024b77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3dc2230d50ba0b3a805af7e6b779550fc971a514202cef92becd93fa259f955"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5da5fe2fbc06f5e6730f7b29cbc04b30c96807e5345004a599ef1513caa0b81f"
    sha256 cellar: :any_skip_relocation, sonoma:         "08e5eb7abeed4c7a7ef0f9630570d53945e63016795e064f9d55aa7fd4619138"
    sha256 cellar: :any_skip_relocation, ventura:        "be17ffdf49787aa16b38d407d3b7a2034bb95a0fff703b62b15292eb8250bd0c"
    sha256 cellar: :any_skip_relocation, monterey:       "18176ab6122460113616500651180d2ea65dbb35f41ce8bab238dc6ed914ed87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "677688e5ee3387bf3d0108fcd58ba428e31a65e3c9c0f7904f840c54850562c2"
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