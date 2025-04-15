class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.104",
      revision: "bc85f9ac47aaaffaf7ca0ff83b7fcb07fd998e47"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5163bbde1295ddaea96486148048e356b6d02c5de898a287be9a706c8aa96584"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5163bbde1295ddaea96486148048e356b6d02c5de898a287be9a706c8aa96584"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5163bbde1295ddaea96486148048e356b6d02c5de898a287be9a706c8aa96584"
    sha256 cellar: :any_skip_relocation, sonoma:        "358d35767b66aeb2d2f52e9230f4a52c123c12f243f5e2fb7c5013023fce852d"
    sha256 cellar: :any_skip_relocation, ventura:       "358d35767b66aeb2d2f52e9230f4a52c123c12f243f5e2fb7c5013023fce852d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be6eaaebdbc4f238205a153cfd53bc9df0a03057e64c0f15d92ea6c6cc41923e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "147790546eddf0ab6d69931b5aca00c2f9d8ace7522a677d0db1ee8e1036eb72"
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