class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://ghfast.top/https://github.com/mattermost/mattermost/archive/refs/tags/v10.11.2.tar.gz"
  sha256 "17aa396db23d949ee74703be8056c3c1c645e7f4ecd1e3433190e4be0c18750c"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "493e9bfac40e27a224c3e528c0e55f1e59b3824525a04bd8835cd29197cebce9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "493e9bfac40e27a224c3e528c0e55f1e59b3824525a04bd8835cd29197cebce9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "493e9bfac40e27a224c3e528c0e55f1e59b3824525a04bd8835cd29197cebce9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba59f9354ccdae527746eecfc0bec085e310a0cb73fbf010ddc714a0c3163381"
    sha256 cellar: :any_skip_relocation, ventura:       "ba59f9354ccdae527746eecfc0bec085e310a0cb73fbf010ddc714a0c3163381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfb587afdc075de7747a7597649ec5dcf207ce5fb0476e745591bd63d53bf919"
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