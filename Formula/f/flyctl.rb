class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.121",
      revision: "1f0fb69280a33483d0516b28606f0254c54d1721"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ab5988fa249fb7bef26f2439ebf60193a3d0c7d115beea2dbbfd49d6221e7ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ab5988fa249fb7bef26f2439ebf60193a3d0c7d115beea2dbbfd49d6221e7ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ab5988fa249fb7bef26f2439ebf60193a3d0c7d115beea2dbbfd49d6221e7ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd270689dd0f3eb12cb6ee22a2fb1fc37109196dd9868536ff6907322e82af3d"
    sha256 cellar: :any_skip_relocation, ventura:        "bd270689dd0f3eb12cb6ee22a2fb1fc37109196dd9868536ff6907322e82af3d"
    sha256 cellar: :any_skip_relocation, monterey:       "bd270689dd0f3eb12cb6ee22a2fb1fc37109196dd9868536ff6907322e82af3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be5ed5212b382136ce53a98c9a25fb2b5c3d8be347e79c6fdfadb2efce4a4c4d"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end