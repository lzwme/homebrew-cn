class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.55.0.tar.gz"
  sha256 "370e6eb0a8694d3948fd655175f472c033ee6b70bfd653e03318b4c8de11785b"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdcc7d25dd60a43d63c347b7de322af4e9e4259382b93538dd341bf086c2d7cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14ba0079f79c45ce661a51577aa2e4e40928923bb13da6394dd73acda84b2c8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83c3b4bbf4e160372a03c65f0f4edacd2022bdd018bab2703a5a55f2a19529c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf3ec2bf197ca6049f79362bf4559ccb2c68ef7d96c1d86642c2d69180f58e88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85438fe9558d4db438cb0512f92a8c5e474bcbdad93262360b4731be59d9e0a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7e9fd8b496eac954a0c16fa3ac143518ae18c726607471405792c9ac92c1127"
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