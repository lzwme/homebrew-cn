class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.96.2.tar.gz"
  sha256 "795bbcc0cfed186a977be2a460dc51b3c480528d8c2a06ff7c210afcf2d4aa30"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf23cfcf53b740d016c22769df00cd0ccf2ee6d428bca1546e435998fb59f527"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f5c61b160095259dd35c5a7a542239ffbdadce4dfaf9d4e2ee2f094072ff754"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ee5e3dd62988a383bfd5b8d415e894ca09b983e7e8f55dea3314f5116280db0"
    sha256 cellar: :any_skip_relocation, sonoma:        "25120397416456d7325aaef9637fdd63ac3d906e26a0f9030f71390c4f1992b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "194955854adf0c5ffef225fcd0542e1d975e033534543f66fab2dab02e782855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "384e62cfa4e992ab1f8aac22b3be69184edd54889a2afbbfd6da511205af4eb4"
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