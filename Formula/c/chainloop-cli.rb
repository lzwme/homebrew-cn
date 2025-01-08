class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.149.0.tar.gz"
  sha256 "739161d926815b0d0003a40c728eef6a06467538c5de9e0985cb1b519877f21e"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6d0008db64e9875d67d41329eb67afd80d12a4a7a4a209fd9f8686c91c04229"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6d0008db64e9875d67d41329eb67afd80d12a4a7a4a209fd9f8686c91c04229"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d6d0008db64e9875d67d41329eb67afd80d12a4a7a4a209fd9f8686c91c04229"
    sha256 cellar: :any_skip_relocation, sonoma:        "20784bb2f15ace70dcecd4d80463f27e21c7075be1da948df296c27fd304eed3"
    sha256 cellar: :any_skip_relocation, ventura:       "a07765fb798c61c2215c4a35c7f99b009d44f573c7cf4038cc05723e24c983ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ca370cafcae7cd1539aedc0daab6f41bef73a79dc1e755a1464748990f49168"
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