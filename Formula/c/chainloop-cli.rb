class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.92.2.tar.gz"
  sha256 "690ca263b381d396da77e93a02db0fccd73b63496c5bf231044ab3071217f5f5"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6b8f15e61d796034de767d940074188f422ee0372e51afab6ebeaadc11d1285"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd22a02e9df28618f9b9ddea1890106c4cf072619c280901df1ea87c42fced57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2872d380058d227d95bdd41af7c1718e4601b6db31b61ae5cb35ceeba16c3cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6bcad0e79bdebd242e90a9ec08fa615949f94b6bdebc7e32c350bb77543c9d3"
    sha256 cellar: :any_skip_relocation, ventura:        "7b4cbaa0b3e3cffcedc2ad10186cb7568c7d837b6b01dd5fc5c0fd8d8af0ab67"
    sha256 cellar: :any_skip_relocation, monterey:       "76592fec3a63874b4c3dbca18afb952c06d47a27773749e6cc757a9b7ebd6888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cce7023b5d08c6f10a3a59c369e737dc46eb3bfcf1685ea5b54111b580a6829"
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