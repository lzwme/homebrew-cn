class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://mattermost.com"
  url "https://ghfast.top/https://github.com/mattermost/mattermost/archive/refs/tags/v11.10.2.tar.gz"
  sha256 "561b6fb1593d75d32c94519d8922a0c68e86eabb7c6af028465d0ccfa8297977"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "78f4abeee0f1c31721ad5a3437ce306f9f095471f6dbd996cb56b04f5138dc48"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "78f4abeee0f1c31721ad5a3437ce306f9f095471f6dbd996cb56b04f5138dc48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "78f4abeee0f1c31721ad5a3437ce306f9f095471f6dbd996cb56b04f5138dc48"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "16a6d2ed62f5ceef831eb68c7e9de3d4cc08a72d70078ac785a64f7fb867e7c2"
    sha256 cellar: :any,                 x86_64_linux:      "252b47e316599fd977d9ee88dd811a947b821e8639432fbc2461fac2b1fd0f27"
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