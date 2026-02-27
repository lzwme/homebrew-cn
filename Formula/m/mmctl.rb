class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://ghfast.top/https://github.com/mattermost/mattermost/archive/refs/tags/v11.4.2.tar.gz"
  sha256 "c9be3204e17bc1ea2578fe1704a53c1b379db780cf8285f6aef6cfe98a163456"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01d277a2de3706674d74f5a179f43722c25d6f5865c6ddf378061b1f7897254e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01d277a2de3706674d74f5a179f43722c25d6f5865c6ddf378061b1f7897254e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01d277a2de3706674d74f5a179f43722c25d6f5865c6ddf378061b1f7897254e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1795ea5e29f178c9af4dd321a0f1d26d86841b5b6f5e55717d9e2d1da6bbc18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "244035720d8965cfb436f89933f1ae3d7b1248324915190ae5d3a58ec627808c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f8acf24f0a59d20bc07ae7e1a0082bb17056c7d2b4b59d023b4ae175c7a9a47"
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