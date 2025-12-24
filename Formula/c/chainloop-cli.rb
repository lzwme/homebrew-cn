class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.65.0.tar.gz"
  sha256 "0c5531b2a9a963ff3ec80d00b9ff0b5cecd56c9aed48e1ea246651c74c61c101"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81483b5c8a889496886cc71ee46e45438814536d10c206c2d1cf29f0bf32c101"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4de0449cea83d833174e7ace14af5cbb66faadbcf3545a87db503cbab66c4071"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3e523c9423f9992e82d011af9ff4174248ac26f3c679a9b6f7a36d2c1ecf66c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c477e0b045fb3459435374e0c7b030fefea46ee6f62e5a61ff31179fe6f8c807"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c4e81a9330207353785bd0e74374fb5dbd5a065d192ead85f800b5d952e19d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cc79e2c470e4f24a4203ab54627ced9ede17c434cf9dbefc934d546ea2b9445"
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
    assert_match "run chainloop auth login", output
  end
end