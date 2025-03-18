class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.182.0.tar.gz"
  sha256 "676d5e0a32854f154e0eebcbf490242298abf0c30e781cc2634d38d6e601b0e7"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34a6f2f205cbddc70afe38b0cbfb9ba93d30dbfd036a72f0381d9a7320c22400"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34a6f2f205cbddc70afe38b0cbfb9ba93d30dbfd036a72f0381d9a7320c22400"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34a6f2f205cbddc70afe38b0cbfb9ba93d30dbfd036a72f0381d9a7320c22400"
    sha256 cellar: :any_skip_relocation, sonoma:        "f106e2dc8d29166ac94a828cdca20a59d19cc4d511dd2c38d9397caf2b359085"
    sha256 cellar: :any_skip_relocation, ventura:       "6f891f49474e0876a34cbbef5c4b292d88f63ab4cba542f828040ac84807dbfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20fa4dac6a877b45ea47106591a97d308ec9c98452fa9e35e4c6fb930dbe057b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin"chainloop"), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end