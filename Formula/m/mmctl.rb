class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://ghfast.top/https://github.com/mattermost/mattermost/archive/refs/tags/v11.6.0.tar.gz"
  sha256 "42614f60dafbe0bf53a9f35e7bdfcfdf1339bc9c45e9c2642b317f6bf3cce0ad"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2041e8190fdfabd60180e262561eae86f1e530192e874a1a7b225dc67c269d76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2041e8190fdfabd60180e262561eae86f1e530192e874a1a7b225dc67c269d76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2041e8190fdfabd60180e262561eae86f1e530192e874a1a7b225dc67c269d76"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0057cbeb6ea741c08e44a8aa728dbc47d0a1b54112366f92c62c6ef7ea63c12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12c37532e9719c34aaaa87ab8009e8db15b83a6832d2ac06240bbba152276763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "581ae420c07b1c63c193a1fd7c5a5cd08fe735bc6602dc32b949599c5bb9ba0d"
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