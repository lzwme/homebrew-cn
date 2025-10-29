class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://ghfast.top/https://github.com/mattermost/mattermost/archive/refs/tags/v11.0.4.tar.gz"
  sha256 "eb3b95fb02dbcf596fa90a4b045f10003b474d1446d8048b49ee1af61ae3c522"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "271dfda338071dd6a293f2f0007c99f7b4effd3e0b8560ffaf3411136aa66c73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "271dfda338071dd6a293f2f0007c99f7b4effd3e0b8560ffaf3411136aa66c73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "271dfda338071dd6a293f2f0007c99f7b4effd3e0b8560ffaf3411136aa66c73"
    sha256 cellar: :any_skip_relocation, sonoma:        "724870e7a94d4884ac843783f64a4fd6bb173ea6ecf70ae7eb7a1a6f6a77a57b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c2b281e91943dc185294bc2b4f86ac49e15646f3b215c51957846dd179dd70e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "829f2600949a037d986fb45926daa8e8e995395787081a45a9bb08658424151e"
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