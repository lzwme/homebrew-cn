class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.55",
      revision: "2e7e50db83543036a920499d6dba43b93fb4f085"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8c6b23b6116f5821c1fb90c638fe779da04c8a1ae6d0dbef0cc7af76970e6cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8c6b23b6116f5821c1fb90c638fe779da04c8a1ae6d0dbef0cc7af76970e6cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8c6b23b6116f5821c1fb90c638fe779da04c8a1ae6d0dbef0cc7af76970e6cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "b19ea501af800eeff08f35329e529d0d3245080553351508ad0596e66f97e566"
    sha256 cellar: :any_skip_relocation, ventura:       "b19ea501af800eeff08f35329e529d0d3245080553351508ad0596e66f97e566"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73775fc47f0233e08c84c422fcbea4536201950c6d8e407335c2f6dd4b13ab88"
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