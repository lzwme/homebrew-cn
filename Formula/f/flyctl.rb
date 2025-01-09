class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.60",
      revision: "9521edbc7676d97949e00d81ccfc31d3a33f3254"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9753736cdf9a7a91adb4e8f6e01c49b4662b8a187af8fb42814a7f79169c2321"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9753736cdf9a7a91adb4e8f6e01c49b4662b8a187af8fb42814a7f79169c2321"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9753736cdf9a7a91adb4e8f6e01c49b4662b8a187af8fb42814a7f79169c2321"
    sha256 cellar: :any_skip_relocation, sonoma:        "33e80411cc87ca360a2c33e9f1d0a14d934872e8727d63e784cc5fc1a95f5000"
    sha256 cellar: :any_skip_relocation, ventura:       "33e80411cc87ca360a2c33e9f1d0a14d934872e8727d63e784cc5fc1a95f5000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6b131713da33977dccb7f265c795cf1de4f32e072dc04035023050a58f8403a"
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
    generate_completions_from_executable(bin"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end