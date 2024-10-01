class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.96.13.tar.gz"
  sha256 "5ae83ee6c36c8cbfe5fe3d5f38c0555ec495c7c16b44834f7acb1082178f2547"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "555d9a7db315cb358db7217a8f501577ec8af5067163ec2dbdb50f522b940fcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "555d9a7db315cb358db7217a8f501577ec8af5067163ec2dbdb50f522b940fcc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "555d9a7db315cb358db7217a8f501577ec8af5067163ec2dbdb50f522b940fcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "01ccf3510a4856ac7daa0b10c23c839633530425d6bb05deae600c3e61d0e22e"
    sha256 cellar: :any_skip_relocation, ventura:       "48b73c3f055e66bb9ad37a22a64c93b0aab70732ace5a7fdae316a528593494a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9f760dea26e9d5a8dc62cce0a043a8b087db3bdfcea2c395c585189c21d73ab"
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