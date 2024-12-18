class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.144.0.tar.gz"
  sha256 "24091b400c3755e4a4eb0f290f1c6d09eebcac91b37e1373cb1ae257cf65feac"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4e46da7adcc4976192c779c179771232244fd5778d17938e0da4a1e5d2c292e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4e46da7adcc4976192c779c179771232244fd5778d17938e0da4a1e5d2c292e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4e46da7adcc4976192c779c179771232244fd5778d17938e0da4a1e5d2c292e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fdefc453e89f0074270cbf00a7fe2af126ce0d5ab4917631fb2d34300aa7444"
    sha256 cellar: :any_skip_relocation, ventura:       "9237efa81ab6047da08abf32146abe779d99aed82280d739231956702dd4b6f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dbf4ae6974f3a0c1e2a9ccda4bd43cc7116e9a27d5e9a63784cfc255dec8284"
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