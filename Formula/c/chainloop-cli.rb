class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.56.0.tar.gz"
  sha256 "7f8e22ccb903d04da04e24ccecf158582b38465d0adf918dd4b26c4c02f60e01"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "803e3db91abefcaf2c3bb88a8b248da8d345900c6665cc01bfa7798caa6d997c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d93e965a9279e97f2b840b8973662b9337f8fe44958a7d61d5b44426c26bc578"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "076814f837fb5e1a8e1e16d0afac8f9187ec12fc5aec3d174ff92c6eca006cbc"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9e5497417b0f34fe6df581c501131d3dfad1b3ef58829b51ab2e98b6a64595e"
    sha256 cellar: :any_skip_relocation, ventura:        "cfa269e0ec0956be7f7e6ca9d8013e5682492931b405d494ecba659871614e6c"
    sha256 cellar: :any_skip_relocation, monterey:       "9caac37bad1fbac70b9a8839e1088d39fec28501c83fc26e33ccf92ee1e0f6f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13f3289a86f285b5dbf1ac541a8502fcbe56af8c5ac9adde16f788f75f6d56ee"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin"chainloop", ldflags: ldflags), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end