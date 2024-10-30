class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.31",
      revision: "87d6db8c5f0c1a4fd59c9dd7df404b7d3f8cb8cc"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff21264d8c18ae5e95f5e03e88d2d9369b6f508b36b0bc3350c1e62af35dc1a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff21264d8c18ae5e95f5e03e88d2d9369b6f508b36b0bc3350c1e62af35dc1a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff21264d8c18ae5e95f5e03e88d2d9369b6f508b36b0bc3350c1e62af35dc1a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bb5aa998e89fc879960de12851bde17f50bdff761e29f01e557513fc4f86a6b"
    sha256 cellar: :any_skip_relocation, ventura:       "4bb5aa998e89fc879960de12851bde17f50bdff761e29f01e557513fc4f86a6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d2f323d923ddd7a443e17bc68f1d4a8e143e8c3fd63aa418ac9527a2cdfb9c7"
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