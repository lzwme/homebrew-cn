class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.176.0.tar.gz"
  sha256 "17f41668de5b31d7ccf3a22f7fe022ded6ab7f03a058a2421799f5bab6d646c2"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cbb4e8d51a30d7005c8c914c88920e589d0bdc8a395f351f681b6a5bb22ffe1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cbb4e8d51a30d7005c8c914c88920e589d0bdc8a395f351f681b6a5bb22ffe1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3cbb4e8d51a30d7005c8c914c88920e589d0bdc8a395f351f681b6a5bb22ffe1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3aebf74e656aadc81909580e48805bc69e7c7503f61d501d9d0d2ff33c3f0197"
    sha256 cellar: :any_skip_relocation, ventura:       "a7d14d51aefea599247aabe8dccb280b789caef1751522e748ad484057ca5bef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fc063ce6952c4632cad22a3c9987bcbdfd41d85d3f8919236dd743e9665cb43"
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