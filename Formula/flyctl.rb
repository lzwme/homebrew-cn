class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.495",
      revision: "b1f95f15eccd689acc11c57421c2337fee476540"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df1adab8482ee15e56bea6afc7c3000edc9a77108abbac4e3370b18951eb6fa5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df1adab8482ee15e56bea6afc7c3000edc9a77108abbac4e3370b18951eb6fa5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df1adab8482ee15e56bea6afc7c3000edc9a77108abbac4e3370b18951eb6fa5"
    sha256 cellar: :any_skip_relocation, ventura:        "771333164f2af9b883641e67e50c464c092f25a955467328d172d025349dec8b"
    sha256 cellar: :any_skip_relocation, monterey:       "771333164f2af9b883641e67e50c464c092f25a955467328d172d025349dec8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "771333164f2af9b883641e67e50c464c092f25a955467328d172d025349dec8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e8ddad3cbe82756cc928526b599ad1e642580d1f8e05e5b4054241f72327613"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end