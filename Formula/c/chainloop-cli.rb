class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.73.1.tar.gz"
  sha256 "deb4e408bbca98940b3ee6a93609cdab268f7a6a22d9246bb90755b050d75edc"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f73bd662707f85442d15f3ff1598034a8429ba016c1de31407f0324d51ae9e9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "703e4e5da5b56d76c3906e4ed7e1641d59b777da0f7118adb0dc92ccce5333b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "547d473e3c54ce97d7a4d59a1cf44daa0bd3b0c97191175c362a00d8fae7af52"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c46a3923f1f58c3650979e6d19de23597a5f08ed80e41cecea86d467b9bfb5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7654919c3b997bb7c775d69133e86c270224667220a0723c98f049ac8b3c4630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa973e42a4b6e77ceb5955a639a1c63b75652efcc093a7db787387c3c9316087"
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