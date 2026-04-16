class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://ghfast.top/https://github.com/mattermost/mattermost/archive/refs/tags/v11.5.2.tar.gz"
  sha256 "6763d56b90bbba761e46f2d671a2eaa3e3ef4ea6d1eb1c53c41b275eb1226f6e"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ce9cafb3f514259c7cd2df3b1e20cc1af45b782e6aaa505d4b659dcaec96c3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ce9cafb3f514259c7cd2df3b1e20cc1af45b782e6aaa505d4b659dcaec96c3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ce9cafb3f514259c7cd2df3b1e20cc1af45b782e6aaa505d4b659dcaec96c3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a85220c623bdf88e874bcec9e978cf73721c349b802aca6113a7d6173e94935"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c69aa5fc8579cb2fb3af97e6f84ff098c899d4db1bb1410de86f6b367d4cea3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "641d9d8d27669861028b8bfc2a28d2dcfaee663cad31a1c1648d7b10bf05d17c"
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