class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv1.4.4.tar.gz"
  sha256 "3ecd5be311bc9569fca2c91b81cab91d8176ed98d25299a7761dae18a1dafbef"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9aa609b05266edd82c1c72709c5cdb5183acca340d6b51bc77da5592a2072020"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdf75328a2e228d931c805192b627a119f771d9ea0c0739dc90b2547cfce9291"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05d48da35366951b3f9434cdb89d5268900fb8ebab9a2c76636a8be35d2428a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "325fa63ce436269e3aae61a5c007f98f6e6cccab21e14bae379e9789fb217e01"
    sha256 cellar: :any_skip_relocation, ventura:       "45cfefb65e16362d48cfb8241fdb4f1ba5adb1d425b7e1f515685fca9bf2748b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d2d5ddb09769b3876cd7f13ed0b3f071efec341e4b1046eb69f5f0c737b9b30"
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