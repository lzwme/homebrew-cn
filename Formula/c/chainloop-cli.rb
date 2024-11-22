class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.119.0.tar.gz"
  sha256 "7aacc32862e0e3ee809750773c99a6e6c9a805c2b7e27b5c87cb37da532a0385"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2facdeeed7ae20360b07eeb814470fb1abfe6fba851ce420142393ba581dc983"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2facdeeed7ae20360b07eeb814470fb1abfe6fba851ce420142393ba581dc983"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2facdeeed7ae20360b07eeb814470fb1abfe6fba851ce420142393ba581dc983"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f92d339e98a7e3dbd93b68ae343722126f743827a3f45eda30a32b9509045fd"
    sha256 cellar: :any_skip_relocation, ventura:       "c40aba8861e19b9098c1d70d4cb6612423e7aed2d3f93d3340341044126593e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46a9d12e1ac8618865b80f3d3b2c1da8aaab0c42be70d1bc6f228f466068975d"
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