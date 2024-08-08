class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.95.4.tar.gz"
  sha256 "805c536b83d1dd632fc563abd11b77349ce8fae6365bcaa13f27c179732c90d7"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15b9d48a3dfe5077ec82bafb4225d1255bc90bac8349816bb6215ac0a1160e34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "279b205bdaff45389e707129d9a7a43f15c1ebfd1834a26fdd4392a267f9616f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84bad70c8e53cebb1411bf01a9c091d7dfbf78a535f283cc2e267e5f7111acf5"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d1e434430be51598e9226e5222fa9a7e49ae9a0466240aa718dab10136f4111"
    sha256 cellar: :any_skip_relocation, ventura:        "d1621a9cb815015c3d93f71f474195368c068d315327910ee95c374d3abcc969"
    sha256 cellar: :any_skip_relocation, monterey:       "7f3dbb96199fd502fe7737427dac5dd053da32f3459abded20b5fe5e98fa9a00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e253f3b4a25ae308092239a15089c5d3ca52e5b6809b44531e97349952a2f52"
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