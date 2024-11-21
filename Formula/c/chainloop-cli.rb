class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.117.0.tar.gz"
  sha256 "7333caa2a7c586c94823413f1e33fb8cfc3ca22d5a66721d2baeb5e2745263f2"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "304de57a2a3bc41f2d5746c69f82402f4b54426b0942f007a2e2e602ccf66558"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "304de57a2a3bc41f2d5746c69f82402f4b54426b0942f007a2e2e602ccf66558"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "304de57a2a3bc41f2d5746c69f82402f4b54426b0942f007a2e2e602ccf66558"
    sha256 cellar: :any_skip_relocation, sonoma:        "a97f79669a83f265fed062c0103baa2237f070cd5e35d9c73e0bddda5e3dbd3d"
    sha256 cellar: :any_skip_relocation, ventura:       "1993ee122112e9c60e5b54833c6b654b66451848288eda247b38554ec33d9315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e31b0f3518f2cbdd1ccb12140241c350c05e82d79a365b0f69577e1be926aa4e"
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