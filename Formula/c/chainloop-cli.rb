class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.87.2.tar.gz"
  sha256 "5e8cf54312b8a13edaef627fd00d61fe003695e3edcf0f1dbe63789e894720ad"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e71f28da9fb0621421a74a1b6430cd5287572e2956d642288aff8a7dac0823c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d9d739a4be328b19ce0212d700fb3ed095e648f5d4cc1879f94175edd13c168"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8177933f594e0760c27982b4029ba5c6c47a57bf315b2d0a9cf3d1d6225c8641"
    sha256 cellar: :any_skip_relocation, sonoma:         "413f7c870ee00dae9b8d183348fad913d46ab27fdd284f09df61e098e9c94fa5"
    sha256 cellar: :any_skip_relocation, ventura:        "0be2ca9e0fd88bd9d30ec9065639e0107fc8e3022884f64baf28726c0c4da9d7"
    sha256 cellar: :any_skip_relocation, monterey:       "b1efad34dd475ea52aee70e454f1ea4d707f3e58e80895c59145cd0926eaf070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba0030deba32f4670157376d86fddb7c40343059bd9abd38678240b6f431088d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin"chainloop", ldflags:), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end