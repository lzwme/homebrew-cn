class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.75.0.tar.gz"
  sha256 "cce5b6e3baa17abc74f6468c2e16f4bb20fe8c66168086e95689dad8e29051c3"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecd88f78bcbef050c76befe66146e1e83724c48803e8c79725c9891fe3ab7afe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "205e37f080f2981b96c5f34679ddb4c5be749825955175f4a41b76c3e9a22df1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8668a0f1b33fd241556fcf5ef6746915a0d925aef60647bcc8087edbdde8c6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a22255af87c4d5f6307271d658210f8cfb10ae1425813f113072ff34f366b6dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "042818e57449fef604f0c4629aa69b0dab7b163e426011c1a0dfdc5b2d8dbee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9e7fcc9bb7a161e105fa40cbc4dad710c95e6a6c130090074b2aa60f66e113b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "run chainloop auth login", output
  end
end