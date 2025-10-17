class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://ghfast.top/https://github.com/mattermost/mattermost/archive/refs/tags/v11.0.2.tar.gz"
  sha256 "bcba98d4cadb880a678bab9f86455d318fa5b8815a9054f467f099bec9d4deb7"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65f01978a48ed92633aa93c511b8447dc061d6f281dd01150c4d780f3513805c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65f01978a48ed92633aa93c511b8447dc061d6f281dd01150c4d780f3513805c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65f01978a48ed92633aa93c511b8447dc061d6f281dd01150c4d780f3513805c"
    sha256 cellar: :any_skip_relocation, sonoma:        "21aabeea9c8af22791a156fa40c58b62fb76352d48bab2cc5ca70e2dfd24a1b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcc2f4560af89d282257027bfd214a3e85d1a63c82a43a5d547445cb54517e59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd92758bcd67a78ca78c2cf4a1259efb2049f9e7a189309ed77be95c3d7db628"
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