class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.1.148",
      revision: "c5e5e013ed93e7e03430eeaa9838900b69e84a0f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40435faff21e373c6648e5e581a3346fce2e6adeb732e7b93c23f29ea414f70a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40435faff21e373c6648e5e581a3346fce2e6adeb732e7b93c23f29ea414f70a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40435faff21e373c6648e5e581a3346fce2e6adeb732e7b93c23f29ea414f70a"
    sha256 cellar: :any_skip_relocation, sonoma:         "f62a3ec70dfc3588119871869c50b277ee9924e7185b022931d3ccb9f53d8bc3"
    sha256 cellar: :any_skip_relocation, ventura:        "f62a3ec70dfc3588119871869c50b277ee9924e7185b022931d3ccb9f53d8bc3"
    sha256 cellar: :any_skip_relocation, monterey:       "f62a3ec70dfc3588119871869c50b277ee9924e7185b022931d3ccb9f53d8bc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea5c52844f0ee39a40a9b205e991cd99f45e4a35a4051c143e8f14b6abf9fab7"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end