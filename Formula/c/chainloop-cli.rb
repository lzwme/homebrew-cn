class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv1.8.0.tar.gz"
  sha256 "126e0c5f47f19d7852abda3fa693fafb296ed73333163de0c57611b83912f3cf"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a25370f6c6202c067d60422c2b23dc6d47c5fdeeffc436d98824689bd72db735"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4510159c418a09d82d5f6146f303a07a720a45b50609fe6d6c2c97297a04352"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4709100f1b4dd775af3c4d2795da6bbe835870a48253df6f52ead33156df38bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c72fd03055a955f4d97b0581bc7ea7fdda3b423a5ad2306e257d3795944bc89"
    sha256 cellar: :any_skip_relocation, ventura:       "762526243bb648202f94209f5e74362db9ce6d0a19763b34a73d79fbede8db65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0adbc90226df311aeea25f732756cf85b4669d5b7c0d429d14da475cef274b2"
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