class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.97.3.tar.gz"
  sha256 "0ac51f25d1f7a6042992a3e9ecd9a346aac0819913ef7a30ad920afb001b4234"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "129d3e42b71a06c1e936cc7dded76d2592f0eb723270054bdeaacf6369790c6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "129d3e42b71a06c1e936cc7dded76d2592f0eb723270054bdeaacf6369790c6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "129d3e42b71a06c1e936cc7dded76d2592f0eb723270054bdeaacf6369790c6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "60b445da5053ee998c13b90a19585ba0278fe71a2cb86343ab4c2cdc3ce1c70e"
    sha256 cellar: :any_skip_relocation, ventura:       "4067240b0c0a473b92ee0bb64b4ae044dd6ede2e793cf8935b85716e069d7270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd78e6c3a815438b728ca82eeafd4e56004f89cadb3af903dfc9ab207e957c9c"
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