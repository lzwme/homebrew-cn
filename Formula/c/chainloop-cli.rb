class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.93.2.tar.gz"
  sha256 "96b76052d2db7cd502a837fb43965e77ebe64d375829e58e04a1059cd17adde1"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e69f1b23f1cbeb9dface3c0724d4228de3013b794a6d7d65856babfcebbf830"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49089d7386d0d0dc944238bcb77976aaec620253cc082ee9bc6389ca7a4b41bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa4947626361cc5f2acff70940ad3d195b80ed424fda6de6f28a6959c1a046f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0537f7ffde52b57d51d6f9e55624a7de940bc364f8a68ec230c4c3cd6e488e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85acc1c05549920d6126b0569de01676a4b6ce6d79c9a98441b4f2b098f224c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "641905ad14b2edfb6422fd5da1fb0abdc5fa558166b16f26a448d54d225f3ef6"
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
    assert_match "chainloop auth login", output
  end
end