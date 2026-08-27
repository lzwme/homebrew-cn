class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.107.2.tar.gz"
  sha256 "0a263f94529c5c714f8507b79fb6c5b02508df87322ad4683ee0c80991684f34"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8c5d65f26bf893dd1da9300bf64a57f6de9352c4965048a9e5ac685d8f18f40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8c5d65f26bf893dd1da9300bf64a57f6de9352c4965048a9e5ac685d8f18f40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8c5d65f26bf893dd1da9300bf64a57f6de9352c4965048a9e5ac685d8f18f40"
    sha256 cellar: :any_skip_relocation, sonoma:        "84ccb66f4edb325dd0ce9b485e4ec2bd6836b821bc0501f058143bbf3017e5aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b578cbb935b27d8683d2d458cac53bbc2cfc8dd5409f9cda6875f4c03dfe507f"
    sha256 cellar: :any,                 x86_64_linux:  "73d43c3f60a01ffec0580e749e5aa7813cdbb051fb317cff9724bcc9bde8c069"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end