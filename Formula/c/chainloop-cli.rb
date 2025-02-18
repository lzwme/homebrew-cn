class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.164.0.tar.gz"
  sha256 "ec1867217c3504abaf83c7f264b326baa8d6a5e2bd637d2039ce00d7b60eac37"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e2a32ee5e5adcdddd0672688a305366327a59494cabc1140d488e13e0e27d09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e2a32ee5e5adcdddd0672688a305366327a59494cabc1140d488e13e0e27d09"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e2a32ee5e5adcdddd0672688a305366327a59494cabc1140d488e13e0e27d09"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc0ea0c9aadce54713d3f725f0a7d72f3da87b36c7f0fe8ad397a8702a6a033e"
    sha256 cellar: :any_skip_relocation, ventura:       "8227c42ab4d671571068fb5cfe30d0e38f26b87ade23d8ad826d6683c96247e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b01de3e168f12b8a6c742aa455f0c6bc3c255209959f6ae57ab15599e8ed5250"
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