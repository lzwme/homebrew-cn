class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.48.0.tar.gz"
  sha256 "257d75a0e2f77e1e13023e5d75b02b78e27462dc763ebb70b3841af7f90d8e29"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b6fcc51844d8fc329482ee7dfa2917a9171920d0aeaf76e99366fb29ba3dbe7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65fd1c11e90fd29676f225019ff2717a335100d11550324d9336268c090f3025"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "280c926918755232b0a84bdcd7893617e6a803f6ae186c6b90bca663693ff6fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e0417af7d470ae9ae867f9f07664bdeb35eb3476ec943e60f1c7fd6292538e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63db95c49305c5363fb1b5331131094dc22b2c027434433fed544ef979fe102e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8bcd0e32c81da0c815278e481a5cdc58d760757854e9bca50c45af9a9ed1ee3"
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