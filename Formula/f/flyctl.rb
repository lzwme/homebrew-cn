class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.36",
      revision: "d5225007479e8909a8c96685212b1a25e1e7e2eb"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89ed68b82f50040d614626e82a837e9b201c9f4f7313869de8a5e8b10f4f1aca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89ed68b82f50040d614626e82a837e9b201c9f4f7313869de8a5e8b10f4f1aca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89ed68b82f50040d614626e82a837e9b201c9f4f7313869de8a5e8b10f4f1aca"
    sha256 cellar: :any_skip_relocation, sonoma:        "28570d9e67dd4c4a4faee5364a0c29e7e803d86f293796766e3d5f94cf96b2ce"
    sha256 cellar: :any_skip_relocation, ventura:       "28570d9e67dd4c4a4faee5364a0c29e7e803d86f293796766e3d5f94cf96b2ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fe48a308ff7c7d340259b22ec137980a39ebc68d992a61d811c778d9704fd7c"
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