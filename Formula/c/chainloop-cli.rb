class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.91.3.tar.gz"
  sha256 "4a61f5672ebc1cc86c2c45027c71a8bc321a042e5f75407db5fa0f307070f6cb"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5d49929a2642e454bc8496f278f1ed5149edaa32ba86e3bdffde72d1449961b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8971655d831afd2af61e81e114bac50834ce50debf46e8c8f11862d664444c3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bf9918b98227cbcc70053476164cf153638f95b4c4cb075fab26da1afd5a331"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d67c8d879442e6de1caa080947dfb763dac1b585d03e2f6db569b717d06026c"
    sha256 cellar: :any_skip_relocation, ventura:        "ef175746d6da359a69a05e6bed095fe906523af655f19277d2ef27f23ef1068c"
    sha256 cellar: :any_skip_relocation, monterey:       "bed9b3cfd90b0a0acbbc42b1b47e7dcc807bd9073ebab71b77f9302d040dd4aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f85d2619d5fd4698ae786aafced24b9a63320a827c6bdf6e9fbee57fd646bf8"
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