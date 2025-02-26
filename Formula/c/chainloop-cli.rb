class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.173.0.tar.gz"
  sha256 "1ba69670ec78a45a9b6af285de5e69a886c11796a6892b825b8bd8be3b8cfd48"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68cc8fc61b86b27531b1e2399269005848a5e7598a4b388ea0b1cf85d0936c55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68cc8fc61b86b27531b1e2399269005848a5e7598a4b388ea0b1cf85d0936c55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68cc8fc61b86b27531b1e2399269005848a5e7598a4b388ea0b1cf85d0936c55"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0c3ff713c831e8272592eabbfbbf5e663781265ece1754ddd93ec0d6e45249a"
    sha256 cellar: :any_skip_relocation, ventura:       "b1debddddb3817809f0e79558f7c9caf79e07c9fba65630edaa31124680983f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10fb3d2edbe6c0f1e4f66ab7061f96941f58b3afcb4069985ad5a039de3911e4"
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