class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.126",
      revision: "4fc5b6ee88645cfd561e1f98c94376aa4a26b414"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86a42854bec54ed82934e6d37c3d6204a0e9156ef7663309059eae73b0259a3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86a42854bec54ed82934e6d37c3d6204a0e9156ef7663309059eae73b0259a3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86a42854bec54ed82934e6d37c3d6204a0e9156ef7663309059eae73b0259a3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "22207c6d41c91eb20722498b1f7fdc51b9989e857c3cc1ff29c6afe3af3c89cd"
    sha256 cellar: :any_skip_relocation, ventura:       "22207c6d41c91eb20722498b1f7fdc51b9989e857c3cc1ff29c6afe3af3c89cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47f3a8e8c4271e55def9eef0f3f50f4dcab14ede5bbdb577a31e9850a6902a6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8197305657ae0469c6babebdf5e2be2ccbd3cea4c232e5ea7aeec1b2508a2af8"
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