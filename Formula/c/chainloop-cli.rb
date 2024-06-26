class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.92.7.tar.gz"
  sha256 "cc088b1be45f4a0f787289ac412b73f2985c0595ff9ae5fd0352d7be14c21311"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f45ae24c09c2b2e4f51fe525d0309fb8fde1df910bef75d7c0d8ab56621944ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71eb35452a2f6e55c327f4d074a4bcfffb5036c7ab7eedfe7d56baf02b8b1020"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "346a63cf3ce58c6de12ed69c9dc052a209a3785815dd6ca625537a2a2c176725"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad8071b229ecf6d1e997592853aab656b7e1bbe220cc6d9f52abf67210943ab3"
    sha256 cellar: :any_skip_relocation, ventura:        "8b735c07defa7552235eb890de7a7a2b45ce5155e3451d0621588eb251fe73cd"
    sha256 cellar: :any_skip_relocation, monterey:       "8f3a74d3621834154dbf9b39644add45993252ce92885adae534d3c426efde9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f38dafad17a62d48cc95850652e275d8a6c19f9339b41aead492c10df6fdc151"
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