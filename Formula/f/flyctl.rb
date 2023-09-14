class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.92",
      revision: "f8e5cccff1f16869d16ad2f8b95f4a396ec771b7"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d96411af091b18879407325adc134c7f75cc6ed5203460b1b75004c7f8ed4e7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d96411af091b18879407325adc134c7f75cc6ed5203460b1b75004c7f8ed4e7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d96411af091b18879407325adc134c7f75cc6ed5203460b1b75004c7f8ed4e7d"
    sha256 cellar: :any_skip_relocation, ventura:        "4d48dab6ff461fc57c8be49a99edad9a2df50487b598090282671a46b5a8bcca"
    sha256 cellar: :any_skip_relocation, monterey:       "4d48dab6ff461fc57c8be49a99edad9a2df50487b598090282671a46b5a8bcca"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d48dab6ff461fc57c8be49a99edad9a2df50487b598090282671a46b5a8bcca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec51e31736293feaff944414154eb97726b6a1acbd8f1ef3cfc71a621eafc425"
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
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end