class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.51",
      revision: "7b0bf226a6fb9ee7af4f08886f409dff052a860f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a558998a1a48dfe5a06c02d3b7bb7c707519cf5be989e8899972cc11a83f05cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a558998a1a48dfe5a06c02d3b7bb7c707519cf5be989e8899972cc11a83f05cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a558998a1a48dfe5a06c02d3b7bb7c707519cf5be989e8899972cc11a83f05cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "83e334c24afc73976fd39bc335c5f4c2859e07dfd1767d8f596e9fa5a52bc411"
    sha256 cellar: :any_skip_relocation, ventura:       "83e334c24afc73976fd39bc335c5f4c2859e07dfd1767d8f596e9fa5a52bc411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c63d2f945263e3f175edfbc3d15e4cbbc443331086f3d68dc9be8f0e086713f1"
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
    generate_completions_from_executable(bin"fly", "completion", base_name: "fly")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end