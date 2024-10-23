class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.27",
      revision: "995c9f2db15b1486c06ee626b94ee96cde639654"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c21fe36f053fd0c3045e27b6005507a2cb563568e2cf4ac774b00b3c7a06e59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c21fe36f053fd0c3045e27b6005507a2cb563568e2cf4ac774b00b3c7a06e59"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c21fe36f053fd0c3045e27b6005507a2cb563568e2cf4ac774b00b3c7a06e59"
    sha256 cellar: :any_skip_relocation, sonoma:        "919139b018278684303342e7cc89c075e2b7d6e9ed79d2baaa42386fc9242d87"
    sha256 cellar: :any_skip_relocation, ventura:       "919139b018278684303342e7cc89c075e2b7d6e9ed79d2baaa42386fc9242d87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a290983a4ac57e0eb50e10489c318e10d94e059e0479b89d823df344bfb7905f"
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