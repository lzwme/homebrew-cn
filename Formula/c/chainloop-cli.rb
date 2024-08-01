class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.95.2.tar.gz"
  sha256 "f994e10328a41f500958e1c16b50f3357155a80f76fde0cc4a539c56a2145eb1"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41e4255b26def3704b2e1871241ae5f82e394410fbb393d55f774fb20709ee9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfddd308732819d14600d5a14833a9cefbd137252b8b3f8f541184e419c83c23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f83ba3fb68ab119169cf8fd1a732a1edbb877bcb927a55ff8151d41bc3f93a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9b9851d365d1a79ef8194e9f884d5395d42be37002d6ebd8fc51f6837a3b5ec"
    sha256 cellar: :any_skip_relocation, ventura:        "d01574cb4288340b213c1140a5a45260f6a9b095304634f24f210fcea24cb621"
    sha256 cellar: :any_skip_relocation, monterey:       "6a7a51432d6684642c9e04d38ab3b751a46d7aa1bc967a78050e94b9ba89af1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cce20155e35ba92307bb333e4e98c18292d78115c5d242df358631cc47045eb"
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