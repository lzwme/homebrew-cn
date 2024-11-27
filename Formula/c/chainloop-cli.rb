class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.131.0.tar.gz"
  sha256 "65449aaf75b4be62eb7fe60423e0f1f8095ab84a823726590cf796f9e90b65da"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fc24014731943ed936692b7e3c5b298c6c897de851605b65bb2b9947ed2f642"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fc24014731943ed936692b7e3c5b298c6c897de851605b65bb2b9947ed2f642"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2fc24014731943ed936692b7e3c5b298c6c897de851605b65bb2b9947ed2f642"
    sha256 cellar: :any_skip_relocation, sonoma:        "faeddbb6232dd36b00027ad3e794cc8251826c6cb6a3fc8a6da7809a324aee4c"
    sha256 cellar: :any_skip_relocation, ventura:       "1001a7f6b9199e0f4a893bd31dd93b2155add8c6d9c0666645b24f5989856381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a43c52d144bdf6e0c6f119cec6ea937b24e53c6ea7383105e00941a00fdb58d"
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