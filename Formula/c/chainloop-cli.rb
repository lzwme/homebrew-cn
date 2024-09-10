class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.96.6.tar.gz"
  sha256 "efbd9b32a09540b78e60216fd0c57249d82a3e2956a38f5564dd817fa92caaba"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4749ffe86b130b75cafb92ebfc7803d1769186c9de7f27ad2f78814f9c46a6e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4749ffe86b130b75cafb92ebfc7803d1769186c9de7f27ad2f78814f9c46a6e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4749ffe86b130b75cafb92ebfc7803d1769186c9de7f27ad2f78814f9c46a6e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "8cd6e443fe0e63136b634b8a6d5eee3033d739097cf8c21a2c10ba2ea5ca2b10"
    sha256 cellar: :any_skip_relocation, ventura:        "5e18ffdb4840882a8b631f05721d9ce172ed2a1f6783fd044dd26688ce7cbabd"
    sha256 cellar: :any_skip_relocation, monterey:       "e4936c1399b697cd034541ffbafb9b220bebb9c1d72e557b5ea5c55b877569b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba598f026f02e37bb59d195059fc39fd70e9774bf58f88c69673957bb51b309e"
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