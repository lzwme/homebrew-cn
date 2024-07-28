class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.99",
      revision: "a96c5248426b88f1c4224736ff9b8a7800dd7607"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a62e431a5fbd430cfbb859d5a543889abe8a078c83a7e2a96996d58c9632145e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a62e431a5fbd430cfbb859d5a543889abe8a078c83a7e2a96996d58c9632145e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a62e431a5fbd430cfbb859d5a543889abe8a078c83a7e2a96996d58c9632145e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a1dff2d5f76ebc5cb52f8f8c96195fc7a4c3d60a8c98de094d8f10afe5b7c0d"
    sha256 cellar: :any_skip_relocation, ventura:        "3a1dff2d5f76ebc5cb52f8f8c96195fc7a4c3d60a8c98de094d8f10afe5b7c0d"
    sha256 cellar: :any_skip_relocation, monterey:       "3a1dff2d5f76ebc5cb52f8f8c96195fc7a4c3d60a8c98de094d8f10afe5b7c0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bbfacecf8655cf65d7e4cb5133cc5703ef06d3559243e98cd52e77187998879"
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