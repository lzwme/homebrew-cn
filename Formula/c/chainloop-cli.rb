class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.99.0.tar.gz"
  sha256 "3455fa61d60e3ad81642fefcd23312582a462886a046fdde4e2a1921fda9efe4"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ccfb1e1fa0adad19200bbcdc20cd264e2a7110f80aa5681f6df1bb37853c0cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55325b6f86956719f2028346f5392a0717df69669bb7aab33c28cd2f8192579d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70257c5e367818c5f3d0a86eaf16eecc59f51e4e7d607b55aca76fcc1fd4c341"
    sha256 cellar: :any_skip_relocation, sonoma:        "36ca7c711566d422f7c8d3c881dd0127ba21eeadf706e9d4a1447e5e3d3b5595"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e6981d4b2bfa6ba8764b9b1d85de182fe9427908f8215b770635bf2d235fd3b"
    sha256 cellar: :any,                 x86_64_linux:  "9c3258b47acfc6be1c025d93dbea346483ceb7bba6f2fabe506ea5dfaf3ce416"
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