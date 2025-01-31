class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.156.0.tar.gz"
  sha256 "3f23fa435799b45010c696e217923f3bc3884cc7ba583c2686c6b8de27c5539d"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e89f54957c926edf2eb426463dd434a829fb07a61cf7717011843ce968f942ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e89f54957c926edf2eb426463dd434a829fb07a61cf7717011843ce968f942ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e89f54957c926edf2eb426463dd434a829fb07a61cf7717011843ce968f942ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "f10770252b2e9baf59492a35b9ec04ce4b9448159bccf87f146c94e54f918f82"
    sha256 cellar: :any_skip_relocation, ventura:       "3a0844ddd98687c134eef1e6ac704ce9bb926fa7515e01f54dc0dcc4abf181cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "136a4098fa724016226aaf91cbc961bf58ead29ec412a0cb49a7a23e78b46aca"
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