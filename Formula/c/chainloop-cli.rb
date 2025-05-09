class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv1.1.0.tar.gz"
  sha256 "a23597a7f69524b652d2cbde7ae3f166f3580bb3c2bd9027daf92147646f46d2"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23bbdf30c04523a8510dbcb7335f47d432e60ee5900a2eab755df7bb05d74265"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5790700ea663d6ddfebeff798fdd45774b7dac0e3e96712d1908ab028858b7c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92cad91ce4a6e4c402522b88d500c6b39d68a8fc0d13fffd41f27d5dd80b34ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7e56dce78e20adb59f521679472786b1db7d347d483a306624fda9947a62e3f"
    sha256 cellar: :any_skip_relocation, ventura:       "bbba81f3d73075c9d8c07435e229a3ae69c8795496923e91c47ede3b54251eab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1c178d9973fb7df4c2e7c4a0e4ac02a089bf3ed3bb84288bd41fbcfa5f77ff0"
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