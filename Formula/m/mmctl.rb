class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://mattermost.com"
  url "https://ghfast.top/https://github.com/mattermost/mattermost/archive/refs/tags/v11.9.1.tar.gz"
  sha256 "9841200551857f08c90c70f5e245cf98cd8d9ed6ae4bfb12b7a9084243cb667d"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdd18880ca64a2abd688c5cb0a3bae91abb8561dee76e5fee0e2e62dd742f090"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdd18880ca64a2abd688c5cb0a3bae91abb8561dee76e5fee0e2e62dd742f090"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdd18880ca64a2abd688c5cb0a3bae91abb8561dee76e5fee0e2e62dd742f090"
    sha256 cellar: :any_skip_relocation, sonoma:        "87a1f86a1a230381781c249d4b98724ec046a76dd36cd4b72a73def81c357f9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26f185ac44e67ceb85d1d2a2c90c961294ad42a90ed3e42fbd84c0db6d52691c"
    sha256 cellar: :any,                 x86_64_linux:  "ac70334db1bf18633373ecc4a5763832606c5f7d661c15941782df0920199b4a"
  end

  depends_on "go" => :build

  def install
    # remove non open source files
    rm_r("server/enterprise")
    rm Dir["server/cmd/mmctl/commands/compliance_export*"]

    ldflags = "-X github.com/mattermost/mattermost/server/v8/cmd/mmctl/commands.buildDate=#{time.iso8601}"
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