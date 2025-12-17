class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://ghfast.top/https://github.com/mattermost/mattermost/archive/refs/tags/v11.2.1.tar.gz"
  sha256 "1bde64f7aa6eb8bd60aa5a6f55a51cec90cd176133fcd596094fa0f135e80ee6"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5c7c3a2c65e6a3b84393d792ba2fe1075aa5e855d0bbb13d5439fc7df4b6710"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5c7c3a2c65e6a3b84393d792ba2fe1075aa5e855d0bbb13d5439fc7df4b6710"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5c7c3a2c65e6a3b84393d792ba2fe1075aa5e855d0bbb13d5439fc7df4b6710"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ad2916281c2bb1ce420842e37cbdc8addc48bcaad54d56dedfff1488d07423b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84385cd8a26111a0dacd84cd44490baaf3b02fbfc3bf25e93a0f08d3ee4f3e2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b8179239e296ea109c451d2f59b725d971001c8aefb49487a83056f54896616"
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