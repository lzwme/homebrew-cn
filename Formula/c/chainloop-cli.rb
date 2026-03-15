class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.82.0.tar.gz"
  sha256 "2b14a711c30682ef3ae798dd37f589ec73b09efddedc9e6316e44f7d5529d05c"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dd1ef04e0d13c9d171a1a53d91b0d460b457a483ea4d87c211fe6c6a5a2bfb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7d517cc203de7766bd66d1445de87cefb2e8d7a0df8ea260ea4fe4043656531"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df9648167ed856fd7d65ba6ec602215574ac0fa0261427572b07aecaae6493d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "87771dcb68c1d0388a79195fc9fecd1e50f414529560f69e0453ed2dbdfd015e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c66dc30553a179a26685dab2d13c3a6ca7ed7cef53e5a3a2a4a1c085f0255eb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af1e1f528ff9c5533c2421c1d5a20a02761efd26b46162919d2a58d8b1b17990"
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