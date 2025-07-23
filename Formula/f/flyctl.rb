class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.160",
      revision: "e2f42de69536e9d040badb24f82c064c0fbdc72e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b141143f01415824bad35306bbf098a46094c9f2cf0ca6989523fa9e2fd28618"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b141143f01415824bad35306bbf098a46094c9f2cf0ca6989523fa9e2fd28618"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b141143f01415824bad35306bbf098a46094c9f2cf0ca6989523fa9e2fd28618"
    sha256 cellar: :any_skip_relocation, sonoma:        "e13100b6daa9dd6aea465802fa8aa6eedbb46ee39866008698841cdb17cab3e2"
    sha256 cellar: :any_skip_relocation, ventura:       "e13100b6daa9dd6aea465802fa8aa6eedbb46ee39866008698841cdb17cab3e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27641bea98b299fbe869e4c7f1f8147239125d8c290b012bc75845f6db2a1f57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98d524102808744c016ba0669e1617b7c1d78cd7e9ce4567f999d1cf31b00177"
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