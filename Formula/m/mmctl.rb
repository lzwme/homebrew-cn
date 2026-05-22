class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://ghfast.top/https://github.com/mattermost/mattermost/archive/refs/tags/v11.7.1.tar.gz"
  sha256 "e5e3f099e22cb2a8b199706889e5b940e7f14b57d5ab08a234ebb06b449dfe6a"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13421bdd778b218c5e86b3b2196efd7bf4118d53fe660009162d57551168bb52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13421bdd778b218c5e86b3b2196efd7bf4118d53fe660009162d57551168bb52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13421bdd778b218c5e86b3b2196efd7bf4118d53fe660009162d57551168bb52"
    sha256 cellar: :any_skip_relocation, sonoma:        "5926fedfefc38394af68fdda5200e252727a708fb6b3cbb211b9a3f85e9c0b56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7d54af68ad96ee28105060dfb2464486e0a60325d659248332724abba008a2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e939251f300d4a0fff40fe1bffa10f0ad1a64474520dddd6861a69ffc0eb6382"
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