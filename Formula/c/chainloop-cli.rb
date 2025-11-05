class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.52.0.tar.gz"
  sha256 "3b1b8cb1b43e23cd64265ddeadbaead2e5fef68612ebe2edab52ff38cec09710"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08e0b6af39a17fadf46c7064a5320738c96b30c7c1d8b66e0851f036b87133d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "171b57e8e0f40a97aea667a2841a28e953d73e5e07d941b78459d13a5ff5c981"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e012b4cc93111cc361017e13a4be99c6d57e336530e9edb43e9906fd02791067"
    sha256 cellar: :any_skip_relocation, sonoma:        "07a214f013d241fc54bbb1a1d80095c06d6e9a251fe72c6abca339521517e10c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8977e313f41c82f763906a1e2a1ee93d6261ecd63e68bfe57892dfbb4af6e04e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9129b8a1a39d013ddce6cf8baeeb95410ba53534d82794b114217182a344b66e"
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