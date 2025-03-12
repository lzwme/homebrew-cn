class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.179.0.tar.gz"
  sha256 "ad0f1c4a8cf0355092ef6cdf1bddc5fc48e6259ec5eac06eb5ec8872ad3c2adf"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b289be365b3370b81fc38d1d5d76233b55e7e4cc75703c62d29b998dc1e3d44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b289be365b3370b81fc38d1d5d76233b55e7e4cc75703c62d29b998dc1e3d44"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b289be365b3370b81fc38d1d5d76233b55e7e4cc75703c62d29b998dc1e3d44"
    sha256 cellar: :any_skip_relocation, sonoma:        "96e8bf9e05e39c178aa49b4bb5b0f201fa23c388f13842bc5c40b1c9b50d001f"
    sha256 cellar: :any_skip_relocation, ventura:       "8cedd96b5cc41d778a82941c1c9016dcb0fddc1db08d80fb99bcc45dfc5ee4a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2beabe2a1ed8cce501fcdeb5a647d6bd4682256f6c6253d394fcd3a0f3923a26"
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