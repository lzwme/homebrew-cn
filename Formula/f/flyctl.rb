class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.11",
      revision: "9ed377272d7c99883158e554c6b15746a0e0b207"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ec79c9001738536c95b7b8d371fabd47742544339d42dd35f4e51e1a7c76930"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ec79c9001738536c95b7b8d371fabd47742544339d42dd35f4e51e1a7c76930"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ec79c9001738536c95b7b8d371fabd47742544339d42dd35f4e51e1a7c76930"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae063583a180b8fb8dca509cf022e10bca6bf7ca02411ac8fa1edf244027a605"
    sha256 cellar: :any_skip_relocation, ventura:       "ae063583a180b8fb8dca509cf022e10bca6bf7ca02411ac8fa1edf244027a605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "741473c61b39b822f8c7eb93fb90a063d0c95977d177f869eb6f728c298d7fc0"
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