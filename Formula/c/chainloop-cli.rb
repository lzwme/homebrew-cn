class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.95.0.tar.gz"
  sha256 "ceb3dbb80984d088750f9952434987e29ea387bdd77eb4dfdbb6bb6192cd9c8d"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26ccbed4f132e4f6f608edf4bf53f6d7dbfae86de5fe1131189adbc18be53e33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e709634ae29fa7c74928b2551a987c227dd1251c8f722c727508acc2601784b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbb0f92d0394d73b2da208471ee2860e2254ac4fc45257a39056d3a499f434f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a615acaabcddff1df219573ad895eeb3ecec73d93bfff66ffea35ab1dac44f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8f1eb6e8262d80a9986fccc0f507472827f42da9bb26f063b0af9a25ef093e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "062a634fc5d45c10d0a6c320cb208522fe46ea23f7bebbba32a699a04d5c2eff"
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