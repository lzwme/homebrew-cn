class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.109.0.tar.gz"
  sha256 "f91a2659ab5ab93fb031adaecf0c586aea241fe60ec427a304b9ec4616dea22b"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fde53bb3f9a17e676d7e90818f15beed12fe50d1e85f38b1cad2025b2e1b052"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fde53bb3f9a17e676d7e90818f15beed12fe50d1e85f38b1cad2025b2e1b052"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7fde53bb3f9a17e676d7e90818f15beed12fe50d1e85f38b1cad2025b2e1b052"
    sha256 cellar: :any_skip_relocation, sonoma:        "c278b4c3f5440b361cc2c1a9add1e2e29e886a5b30f031238552386ce12f6131"
    sha256 cellar: :any_skip_relocation, ventura:       "63b8164e3ebc96ea6e6d17e1251a5600187b984d4acfc8a71204c4271e7283d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e92d6932b007986a991f85076da35e990379fa56fd9ddedd8d2eb75cdbf9ddfc"
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