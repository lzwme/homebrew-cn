class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.137.0.tar.gz"
  sha256 "a4bf58c521c5eb5a93e27369a09672bb7b493c52f199193557d585ac2861cca6"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b62fd5a6ad4b35a1b4528a91ed25ca753b2a64a73e392dbe4e4bf4b5be4ce7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b62fd5a6ad4b35a1b4528a91ed25ca753b2a64a73e392dbe4e4bf4b5be4ce7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b62fd5a6ad4b35a1b4528a91ed25ca753b2a64a73e392dbe4e4bf4b5be4ce7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a37ddce8e79baf16a3d40e91c31609f7f7fc459fcf3f91d08d704a4b15bec4af"
    sha256 cellar: :any_skip_relocation, ventura:       "3d143454b9c9d6d8e8ee26ad2df763981f361c7da3a3b80dbac23fe7d86df149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff66e3bca08b3a5bae357f75a11f282211f4cb37da31c5ae458a794561bb6ec8"
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