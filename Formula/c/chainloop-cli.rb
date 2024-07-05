class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.93.5.tar.gz"
  sha256 "e7ea5e4e8853c68c83daa3580c9c9ba99b1686737e44cd3bb431edcd476a58d3"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34f8b791048bfffeda4f0d4182ec63df188e5a887b83c01fba4c822b464f5a42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83f0aca276fce3dcdcdb0077ebde868c510592334bdaee5210b0492c745717d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01e83c093a8e06c3fbf217e19943a4474200721c37792e45804daf2067bad66d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3c735f25b493f8fb6ddfb1f4d9d165ab041f0d9d07e74ac43f8d97d7b35a406"
    sha256 cellar: :any_skip_relocation, ventura:        "58979f422e2f412e7be911be3ca55fc0594fbd4a76998946e2fcd539d9452a9e"
    sha256 cellar: :any_skip_relocation, monterey:       "258c134cdb7d9f5ef17c8f69d7f9434f92fc4a8536fd0d673c5952239e1980e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "208c417032ad5e9230c23c54ab0f3d85609bace240fde55ade9aea1a2cbc062b"
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