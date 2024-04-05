class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.81.2.tar.gz"
  sha256 "50e4aab28d3d5eab610114b0479477e4afc2f0ace1237b1e32f914dc7a9ca1d7"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da06e56ec9c43b87a281110deef25c4495d95e4eb730e8d5cd78c0dab0b3206f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00dde3508be68522650fb6810eb6d126a79383135df7ca456107fd428366b994"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4105c780ec6522a7e6455f243b082b56c9bbcf3e21481dfa98a88b760a70f593"
    sha256 cellar: :any_skip_relocation, sonoma:         "51f78fabd4bf988cfc04b044c4f03d4eeba50d702a9fc4352f9ca6656c24d12c"
    sha256 cellar: :any_skip_relocation, ventura:        "482d34f81d7795dd04500b8e577ec933f932410754e55efc962b138e69d1bce5"
    sha256 cellar: :any_skip_relocation, monterey:       "674fd034aa5fa76a3a0a0cac2445725507db2eb0da71455e05c9b27b5734f547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cbc57aa0c1fc672371e86118c4cdaaf241d105106d6fcac63b2d17eb482294a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin"chainloop", ldflags:), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end