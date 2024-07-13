class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.93.7.tar.gz"
  sha256 "7cbbda1e5ab71fef561c0f123f5f584c8e0de523d4da80379599ce7a05c04c1f"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99230eb020056ce8cd3c833346053ae396ee1e01b173fb64ee776e430b9fd26b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0439ee21eaaccdd9d96faa32e817942273252ba4b7b9c379e9f1931419823148"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "416443b72b61f375a8627948342d8825bf29a128baa1a2a8ffb83630b71f189f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3990e94604ed22dfa62ae0daf42e177ff48e483a007bc0dff8744be07a6061a"
    sha256 cellar: :any_skip_relocation, ventura:        "89e2fa40c9b1f224e61654aaaaf0979b9adfcca0cad380be2c58d59c9e50fc16"
    sha256 cellar: :any_skip_relocation, monterey:       "5531cafbbfc8e84b20f9f9a889a1cb4455f3f54fe097f970de21516113645b52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f51ac07325190e487e70734ae9804851a6bcf870b291971d7c45390a8f1dbae9"
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