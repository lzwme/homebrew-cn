class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://mattermost.com"
  url "https://ghfast.top/https://github.com/mattermost/mattermost/archive/refs/tags/v11.11.1.tar.gz"
  sha256 "1a7702e82e82aa3035037687070cae7b5debfba37401be02ea61985e51c01b99"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a2ee5c11c0eb3b6b2231334680095be3187255bd7939041566f289bca4aff758"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a2ee5c11c0eb3b6b2231334680095be3187255bd7939041566f289bca4aff758"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a2ee5c11c0eb3b6b2231334680095be3187255bd7939041566f289bca4aff758"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a949933818a245e38519b596dfde21a1cfcb9540ccbc204bcdd1e898cd4381a2"
    sha256 cellar: :any,                 x86_64_linux:      "abaa7f2a243341d0183f76a92aab10530f373cfb011cd1aa397f122e1f0f0223"
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