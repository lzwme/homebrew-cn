class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.91.0.tar.gz"
  sha256 "70b24fdfd12c9b49927eee8e7d1cdd47c2404b1627f61d53101111b4f509ecbb"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c1481e6f70911bcb10b6bbdbf89667736d9ce821680c52ad80a1116bf307f71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb984a01a0ad71f79d6482981252283cd3b61c612c2f357964c05040601c6712"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "370c3da4aae1feb4f4ffb2e9e96e488ec93fb83bd12e7fad89c09ed76430532e"
    sha256 cellar: :any_skip_relocation, sonoma:         "d23a71d5389c1ea1dd4061371e99998971aefc2071ba9c4d62992b2225131a36"
    sha256 cellar: :any_skip_relocation, ventura:        "85e3f2e3d9c542a66fabc307f7d0719994319c50be0801c30ba8479af5165e28"
    sha256 cellar: :any_skip_relocation, monterey:       "577fb32f05a02a68c533701ae3e0eb4ca68505c859c9fd616023b4184803087b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47734ebc4721116833c5b543eeba7c860361d1d8743e2b9393fd7dfe785df335"
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