class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.148.0.tar.gz"
  sha256 "99c22ce10a9c765aea662a59cad8cd484330845118c6030368062293521fb8b8"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cd37417365ad3ea029087a1e4cbdec9b0d35068fb82484995dd6a8cec27a856"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cd37417365ad3ea029087a1e4cbdec9b0d35068fb82484995dd6a8cec27a856"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4cd37417365ad3ea029087a1e4cbdec9b0d35068fb82484995dd6a8cec27a856"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9a7f2031271981c51278cb6895bbb321ee1708fe488be67a609f50fa04802d6"
    sha256 cellar: :any_skip_relocation, ventura:       "766c3ac77445e46ed4e61662b50b920ac98942313de127cb2dfa48a8664b803d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d08d7c18ca0e5f27481ea9af6087bd7d099d21c7d3fee8a32da1a8218e2d05ed"
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