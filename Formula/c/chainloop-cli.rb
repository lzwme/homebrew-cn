class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "7e9ace5964c2a309904189d5e9ca51b00d5ed5811455f36ee3efb1f6e7640518"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8a59a1a6fc76188e87b9db16009f1c6c2e6237c0b8a63620f0ab495494d7778"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35dd0ab3f55ed058a9776c2deb76badb3ed764c3b03883239d9967e0dfa90bce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d2594a55cfa2d87d11d6e33197a314968b2e3e11fcaf03326a8c063e1bd7c79"
    sha256 cellar: :any_skip_relocation, sonoma:        "019c44bcde112d7bd4cba142eba1c7a33128b467a5036f6a45e3965bd8c7334a"
    sha256 cellar: :any_skip_relocation, ventura:       "91dd6f3e61fb4170b7d2eaf528f4922afea494858bf09e0ae6435a923fb4225b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3830b38686c63a6ab54c6dc33be934752d516d8105e6965da0003153d71f7bc8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end