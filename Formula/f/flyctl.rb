class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.145",
      revision: "0c9ff827093f48a9ac8a4f7f89c35dc08e49d0f5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4d863de185b74ed3e84f3efbc0a540abc86025fb673391aa9150b3d55d55dfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4d863de185b74ed3e84f3efbc0a540abc86025fb673391aa9150b3d55d55dfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4d863de185b74ed3e84f3efbc0a540abc86025fb673391aa9150b3d55d55dfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d5bd3a39e240f2724646565b2afe844de1fae90fda72fa2dc70793f842d484b"
    sha256 cellar: :any_skip_relocation, ventura:       "2d5bd3a39e240f2724646565b2afe844de1fae90fda72fa2dc70793f842d484b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b361a2ca2edcacd86999d6fe341e88ec6704cb41ee57430701d78c37e0fe144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1eb5fa7819745b2305c47cfdfeed06303b35e818df450a713c6de7b76a48ea77"
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