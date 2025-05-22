class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.129",
      revision: "2397eb6bb19e598b642ef7365e91ea08fb845ace"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37316bcbac0b848a4105b5336e6a0ff2ba743f17a507b126fab1cbc7721ab3d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37316bcbac0b848a4105b5336e6a0ff2ba743f17a507b126fab1cbc7721ab3d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37316bcbac0b848a4105b5336e6a0ff2ba743f17a507b126fab1cbc7721ab3d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0043285262efac42992330cf2b20202ee9a535d4c123f567f857e35988d72bfc"
    sha256 cellar: :any_skip_relocation, ventura:       "0043285262efac42992330cf2b20202ee9a535d4c123f567f857e35988d72bfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1b2d181369a95a4f11424ebab62aeb8000ec7e81536887f876a828b2265cf43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "783d87b3334e58fe0688cbfff47f3f9626bc04f59c1d56d0f00e85000908adcc"
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
    system "go", "build", *std_go_args(ldflags:, tags: "production")

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin"flyctl", "completion")
    generate_completions_from_executable(bin"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end