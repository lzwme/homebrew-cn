class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://ghfast.top/https://github.com/mattermost/mattermost/archive/refs/tags/v11.4.1.tar.gz"
  sha256 "a182bebd6485e71ab8ee9ef17ae7f5c5e73d6e8bbe04cfa0f14d18606eba71de"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "681c7aef9307549a9d6f7f08c645470252e22aaca65dfe9968db69fabbf68eaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "681c7aef9307549a9d6f7f08c645470252e22aaca65dfe9968db69fabbf68eaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "681c7aef9307549a9d6f7f08c645470252e22aaca65dfe9968db69fabbf68eaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "019d0dea6c1ac202ad067f395511bd72bedb0301edee73ee631f1c04b83f00cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4741c0719004e4c30d7f4d983be1916d2e8ee5c9f681bb6feb2a3d1672671548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1dddf0187b384eb8045e32359d8c5e4cacfc4f4a435e6e18c1d077d0bee3770"
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