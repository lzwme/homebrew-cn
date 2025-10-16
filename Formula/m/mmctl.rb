class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://ghfast.top/https://github.com/mattermost/mattermost/archive/refs/tags/v10.12.1.tar.gz"
  sha256 "65b094fb4f5d40c80475d592e671d9ec2e2ff6f678848a5f183cb7e464c25c03"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5da70740a10246456fca35eeb62fee79b66c0100c3b9deed24396e79f69d4674"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5da70740a10246456fca35eeb62fee79b66c0100c3b9deed24396e79f69d4674"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5da70740a10246456fca35eeb62fee79b66c0100c3b9deed24396e79f69d4674"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4aa92bedf6ca4628e20c35a6781b8435b0433cb57e2571ac2168dd14b77fa4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6267481d14665195a9ecc2fbad9a8e519d7c851aa834a0885b5d49f4b5d2c108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cae07f0e0a4c6420b4b71dabaa373c0b2db551107ecec1f13f2cb458cf60d60a"
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