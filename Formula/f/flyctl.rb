class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.108",
      revision: "4b3bdbddbb850f4933ba42266f43eb5a0cfdf139"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d896c8e115c27726eee351f6276e6f8e5b2ba52c75c1d08db7e5ec960c8716c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d896c8e115c27726eee351f6276e6f8e5b2ba52c75c1d08db7e5ec960c8716c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d896c8e115c27726eee351f6276e6f8e5b2ba52c75c1d08db7e5ec960c8716c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8017c0e85f7c7c18c85deb14d010515b9a5b509a0d8fb28f99d59b7506f0df2"
    sha256 cellar: :any_skip_relocation, ventura:        "c8017c0e85f7c7c18c85deb14d010515b9a5b509a0d8fb28f99d59b7506f0df2"
    sha256 cellar: :any_skip_relocation, monterey:       "c8017c0e85f7c7c18c85deb14d010515b9a5b509a0d8fb28f99d59b7506f0df2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01fa788e45d79fa791607160b4bb5ef88476ab53d9e71f9267ba91c31799d5c1"
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