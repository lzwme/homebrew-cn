class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.141.0.tar.gz"
  sha256 "4703d09fc8fb52e6e264694f5c32f2b78c6399e291114dff331c26a49ef15228"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b4d794e2e36d37744ce436bc0e1a0dbffc6ad9214b195db0a6f6d338fcfdcf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b4d794e2e36d37744ce436bc0e1a0dbffc6ad9214b195db0a6f6d338fcfdcf0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b4d794e2e36d37744ce436bc0e1a0dbffc6ad9214b195db0a6f6d338fcfdcf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "dee6b05bfb9abfc82b4fbca4b211a7f58944831a578134965bed256795630677"
    sha256 cellar: :any_skip_relocation, ventura:       "92ede88d21f6a00f47f6de678d744d39d5e9fa67f01a986b59cc7c4703bf30ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae80b22d82b3ac198d456391ee1dc4dcc3fe9e1708dd59d3ad862359c4fe7b75"
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