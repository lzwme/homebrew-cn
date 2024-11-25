class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.127.0.tar.gz"
  sha256 "81c37da6751af0154b5d3c1c65dc79f8fe9f027518dced50da179f1777dc02a7"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4d75e66f2ae9a02786792c483ec53520792fcd69939f92f35e914b4f5d53233"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4d75e66f2ae9a02786792c483ec53520792fcd69939f92f35e914b4f5d53233"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4d75e66f2ae9a02786792c483ec53520792fcd69939f92f35e914b4f5d53233"
    sha256 cellar: :any_skip_relocation, sonoma:        "16e3f0dc4b57dc9fda703024170cec0e9304455a36aa716e16b9a7462174f444"
    sha256 cellar: :any_skip_relocation, ventura:       "70b123d204e903ee64b659267206dfa5b0671dc8e09c11436fcf586a65287f42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c174dd3c23813e2eb42ba7af59142dadf9ff7e24aab2d9623476eb2c1c88bb9"
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