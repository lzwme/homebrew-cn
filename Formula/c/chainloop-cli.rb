class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.146.0.tar.gz"
  sha256 "f98f89aa5842c4736cebeee5a593734a23bda605707f3374db6cec3424cb0a04"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4241c49df238ac3d58da6cfac4d389600c63a28c495275d6a41a69c3434a7856"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4241c49df238ac3d58da6cfac4d389600c63a28c495275d6a41a69c3434a7856"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4241c49df238ac3d58da6cfac4d389600c63a28c495275d6a41a69c3434a7856"
    sha256 cellar: :any_skip_relocation, sonoma:        "e17dab0ec2905b2ac8671fed3a6ca6664b06adf1fd1795112ca22701bc910647"
    sha256 cellar: :any_skip_relocation, ventura:       "03fda90087872db2f1b0f97314cf55641bd72d53e9fbcc7a5c0f49336725a896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2562ce86bbcb471dbb25b686aaa683300c67482dcbfeb42e4c5d4f8154cabcce"
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