class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.166.0.tar.gz"
  sha256 "e7283b2fcac538f001ba08d15b56fba81643e814a429526d845996ff6089dcda"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3a0462386f0576106ae1e3b652e37cde2f182f9a3845e4cac349e9975b4166c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3a0462386f0576106ae1e3b652e37cde2f182f9a3845e4cac349e9975b4166c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3a0462386f0576106ae1e3b652e37cde2f182f9a3845e4cac349e9975b4166c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e622e230a5606d4d69d380df75734a2a5a9f4f746d59ba98c614bb0765950cd"
    sha256 cellar: :any_skip_relocation, ventura:       "01b5c458d909813164e72d5e6624422acd2ddf57575829b5e14d0e1f5e76b559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be7ab4ff3aaa060ddc2ef8d8bb99e7ad9a1621b65dc4af88ef390c6c864af9f1"
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