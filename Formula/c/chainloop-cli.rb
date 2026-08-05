class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.105.4.tar.gz"
  sha256 "502d27bc112b95b1b296c0c277ac64ba336169ee4f0a6ea5c447d40c0a476c0a"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ac4d1c06dcda2a2ba470d63e4eb8320801dde62a02840996aecd8b7d0ff1fd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ac4d1c06dcda2a2ba470d63e4eb8320801dde62a02840996aecd8b7d0ff1fd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ac4d1c06dcda2a2ba470d63e4eb8320801dde62a02840996aecd8b7d0ff1fd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c46234737b8e2d3fa5e7dbe4a0f96eb00a2d94f2ab62546ce21fb17cbc6e2f31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8eb1ed0e0c9094fb44cf140881d1ef43fc216aba485df3882bd5bb9cfbef2d7b"
    sha256 cellar: :any,                 x86_64_linux:  "9ad00083cd2b5a82aed9beea7128ec38af24952ea767dfb952acb8df893c107c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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