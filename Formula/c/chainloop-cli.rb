class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.96.2.tar.gz"
  sha256 "a255a38c4fd5133b1d601a4b442df15a379b851e158eb0e80207e2210bed9ad8"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2864468ad6e3848c8acb10eacc9ac5389aa402fa0942e6c049a8d7ea59ff35a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2864468ad6e3848c8acb10eacc9ac5389aa402fa0942e6c049a8d7ea59ff35a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2864468ad6e3848c8acb10eacc9ac5389aa402fa0942e6c049a8d7ea59ff35a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "92f20da05b8739c2becf9fe0b49d1a56593a3a03a26d308b071ac87346b96cce"
    sha256 cellar: :any_skip_relocation, ventura:        "547fcba0bb9f58f8cdbe38eb22eed437a6278d101268d5c9fe4357e2320f8c05"
    sha256 cellar: :any_skip_relocation, monterey:       "4fc272b8df92a6a7068aa71a140a04d8fb38c543cdb7c14741005fdc432d9528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be40d06d1699a459626a7140d12a7dfad4a8e4483ef4cc570fbdd40025a2d4a4"
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