class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.158.0.tar.gz"
  sha256 "4cc984de649086d0e551f0516e3aa9e058a85e6c71240dcb8c33dc76154d32c0"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8ee582ffd4ae4f462be661d03fec5b36c7e06321a372257f62304e4557b491d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8ee582ffd4ae4f462be661d03fec5b36c7e06321a372257f62304e4557b491d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8ee582ffd4ae4f462be661d03fec5b36c7e06321a372257f62304e4557b491d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e04caa390eb73586851bbfe65865d3ba7bd8563df79f8b018397157a3d070a0"
    sha256 cellar: :any_skip_relocation, ventura:       "2f8983f7afc4ba0e70056e04c54458c4485c941f8faadaa862bcb31df3fffbd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b69ccdabb17daaf26974cb6b1a378e54635d5161bfc1226e70875a23b123af2"
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