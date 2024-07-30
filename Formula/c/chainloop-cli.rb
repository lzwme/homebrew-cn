class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.95.0.tar.gz"
  sha256 "9538f0d14623a95d4dc66bfb8a81d4e037d3331c987daf2c03e29a944210ba9f"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a585f1f1d811194de6f7e93e0e4f03a7522ca7bc8213a9f4c4115b2701b9bd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37405e29fbf6a6fba0979150db6bea1a0835c8520e13800db0a385abccb09a94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3bb46260c359c00a44c030d994e59eabc76baef6a6a438b232ba12c6fb692d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "af1cd47dc7c5dbe6e9c3029ed3d9b2240688ddc2a6a0058bade1ea4fd05be365"
    sha256 cellar: :any_skip_relocation, ventura:        "eaaf0f4ce711e4cd82a98376b3ee7e3554c4ce2be5812c4115651dc0f03fe359"
    sha256 cellar: :any_skip_relocation, monterey:       "e45679dd6ef71e3ceb0935f8ddb41b64df73e05d0f81d4f1872b5fa495d840f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b6b51df40b9ee9832961093a8819991d2becb1452c7d0c9c029d3d2cd74b655"
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