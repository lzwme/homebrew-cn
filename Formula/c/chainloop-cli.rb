class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.124.0.tar.gz"
  sha256 "596fd1745e212c2cd660030be60ae457eebcf39fe5f9b7f602dd5d0a54129897"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e545435d0ea79e0a6560d5880bc8aaaafad8eb6474f96afe72d08a64ec279e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e545435d0ea79e0a6560d5880bc8aaaafad8eb6474f96afe72d08a64ec279e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e545435d0ea79e0a6560d5880bc8aaaafad8eb6474f96afe72d08a64ec279e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9a8cbf84a2865d74ed4e88073e410c0dc4a675bb51d1eb87e96566e8006fc23"
    sha256 cellar: :any_skip_relocation, ventura:       "dc0daf46334b4d25b02b68d5accc76da9b128c52e6959ef9326034c102eec663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96cc0bb16d02459935234bf5bdf03f1d370fe49247f7dbb2cb699edbcf593a17"
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