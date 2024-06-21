class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.92.3.tar.gz"
  sha256 "53bc2d51edffde3dbe63e78ce4095f66490ed89a84fbc0a216cd3f8a4b91a20d"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35637ed24e9e4def86498bcf63387b08c47fbc050e2b90de305859c326030338"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70a40030d82396ac1716840994f0f6c11531d5685eff72c76c6cdae48acca01f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d633acd2a9331a6316bf3fd79ed18ea9f101144d855ba55a088a750ec133ad3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e46d32830ee7bc741f967a9a46b18045d958d2fa93c587e5a5532c988942fd6b"
    sha256 cellar: :any_skip_relocation, ventura:        "f91481b6536c4aec48c56b5c6a647538308c60841f4666fc303c0c97a2a84e46"
    sha256 cellar: :any_skip_relocation, monterey:       "c7aacc8a3becac4fd923284ea75276f6320d77c0b7553b36df04a9fbf5ee538f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a1a7c5694641d0bc49f2de21e4b209db9985136f8d704f982d66f023629f1d1"
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