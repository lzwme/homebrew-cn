class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.145.0.tar.gz"
  sha256 "8795aa1ffea58e2d8e5daa01154b5898bce0eb965ed9c3b5bc38008831678959"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c5fd241bec7d517360004c61ddf176fc0d387352180daecfa104f076794d94c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c5fd241bec7d517360004c61ddf176fc0d387352180daecfa104f076794d94c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c5fd241bec7d517360004c61ddf176fc0d387352180daecfa104f076794d94c"
    sha256 cellar: :any_skip_relocation, sonoma:        "38528ed4698207caeb4e258da7d77610464568180f19dfdf137eb87eaf5e4268"
    sha256 cellar: :any_skip_relocation, ventura:       "19d5556051cded72e2988cca22d1aa155ba5f4b85b9d2c817dfffbcab3469f6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "340d4478f0e0fa8b3c4fdf637cdd9840ae98b26471156039f9725b6c26524144"
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