class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://ghfast.top/https://github.com/mattermost/mattermost/archive/refs/tags/v11.3.1.tar.gz"
  sha256 "ff50fce9da149f46762c953b14ea5bb65df11740a65a1ee30a55294027887cec"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d61b64f573e728fe127002bcf9e967397f083cc885250d5a3abe2b473a04e9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d61b64f573e728fe127002bcf9e967397f083cc885250d5a3abe2b473a04e9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d61b64f573e728fe127002bcf9e967397f083cc885250d5a3abe2b473a04e9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cc8303fd6abdf8e44fbaeb6ac7a483b6d5f0c23d8f56c0505ec8810a592aa13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc0de63711a0568f6859981c5ce233216e55400be8a9ab5157a8ad09583985fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df754937d8e6120c93857ace742803a692fb1e12da397d0456bf47a6109af5d3"
  end

  depends_on "go" => :build

  def install
    # remove non open source files
    rm_r("server/enterprise")
    rm Dir["server/cmd/mmctl/commands/compliance_export*"]

    ldflags = "-s -w -X github.com/mattermost/mattermost/server/v8/cmd/mmctl/commands.buildDate=#{time.iso8601}"
    system "make", "-C", "server", "setup-go-work"
    system "go", "build", "-C", "server", *std_go_args(ldflags:), "./cmd/mmctl"

    # Install shell completions
    generate_completions_from_executable(bin/"mmctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end