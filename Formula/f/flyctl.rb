class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.7",
      revision: "e6cdd344345c3c8866ed1def91e75df950697ff5"
  license "Apache-2.0"
  head "https:github.comsuperflyflyctl.git", branch: "master"

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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "787bca811683f85af52b6f186ce56e204a6159a22125d73f5929a7c9ad128950"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "787bca811683f85af52b6f186ce56e204a6159a22125d73f5929a7c9ad128950"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "787bca811683f85af52b6f186ce56e204a6159a22125d73f5929a7c9ad128950"
    sha256 cellar: :any_skip_relocation, sonoma:        "919483a8c9b6f8576e7d3ddca8bd9b832146f1412db2fc58ce4be69016ef30e4"
    sha256 cellar: :any_skip_relocation, ventura:       "919483a8c9b6f8576e7d3ddca8bd9b832146f1412db2fc58ce4be69016ef30e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3520cf0671ac8d1ca0759665186724cdd6f08b79af71084d5835438e84f1630"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.comsuperflyflyctlinternalbuildinfo.buildDate=#{time.iso8601}
      -X github.comsuperflyflyctlinternalbuildinfo.buildVersion=#{version}
      -X github.comsuperflyflyctlinternalbuildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end