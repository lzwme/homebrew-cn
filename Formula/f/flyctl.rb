class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.169",
      revision: "751fcea33be3e38ab435c815acbd03a61bd42d6d"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d955abb1c5702a7444263471e2339c8d2e77be1d6c7a7f2d12e3862b21b67498"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d955abb1c5702a7444263471e2339c8d2e77be1d6c7a7f2d12e3862b21b67498"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d955abb1c5702a7444263471e2339c8d2e77be1d6c7a7f2d12e3862b21b67498"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b671278a171cc96e1bc030878fd77700366446cf798fb0a25d1484604a948dc"
    sha256 cellar: :any_skip_relocation, ventura:       "1b671278a171cc96e1bc030878fd77700366446cf798fb0a25d1484604a948dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b180a4891eb2f88abadb025d93f19a21e2b11840b7cdab9198886ff70761050f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "870813031ebcdaf33d46036732c7b8e047f427280cfd86cb484e0af6338b0929"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "production")

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
    generate_completions_from_executable(bin/"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end