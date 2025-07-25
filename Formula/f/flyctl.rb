class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.161",
      revision: "db4d3b0282693e9fcb29e115ec1bdfbbb371addd"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8e488776f3110c20c86f2ea56d7218b8ac83d44d9df3f253d8896681f20e540"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8e488776f3110c20c86f2ea56d7218b8ac83d44d9df3f253d8896681f20e540"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8e488776f3110c20c86f2ea56d7218b8ac83d44d9df3f253d8896681f20e540"
    sha256 cellar: :any_skip_relocation, sonoma:        "298dc6de1ab513a424c41ebd9feac6c99bd0a816462c5638df126a1af0196625"
    sha256 cellar: :any_skip_relocation, ventura:       "298dc6de1ab513a424c41ebd9feac6c99bd0a816462c5638df126a1af0196625"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ecb9877ae7bb5e8fe2ac6f1855bf71af0ca16cb7bf37ce50489e869865c039e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba87905c6494867fbff195d3980ecd32826baed2dfc4a64e0552fa1f4647f471"
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