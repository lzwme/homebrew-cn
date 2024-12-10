class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.136.0.tar.gz"
  sha256 "f0671fd339d8fe3552f15a6a676c35414ea669fa369a65550cae776d32609f65"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f983e5292cecb930a1d25da4f8013c33e2243d06950bc52f06cdcb6fcdeb248"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f983e5292cecb930a1d25da4f8013c33e2243d06950bc52f06cdcb6fcdeb248"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f983e5292cecb930a1d25da4f8013c33e2243d06950bc52f06cdcb6fcdeb248"
    sha256 cellar: :any_skip_relocation, sonoma:        "411e003a2f9126fd4dd25ad9c26c9250795c02090d7da13628e7d51df34cb838"
    sha256 cellar: :any_skip_relocation, ventura:       "b22bf5fe1594df777f9d87f08c13b9d04499c8088dd1b3155b582177aac36f7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eec93fc7ffd4f60f0922fee70fcff8799229484a5723d902cb43d7c4bf86fb3"
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