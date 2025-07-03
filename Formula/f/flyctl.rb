class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.148",
      revision: "e3f35d9b1c906ecb7c788a02d7668be62638ba97"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a39c14a43d421a4bd12a16752275473f5c36919de1220e3443a4f9e906a338e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a39c14a43d421a4bd12a16752275473f5c36919de1220e3443a4f9e906a338e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a39c14a43d421a4bd12a16752275473f5c36919de1220e3443a4f9e906a338e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8efe18a524dd30548bd96d66d896e301b5a04bb789d7f9921355614509129d58"
    sha256 cellar: :any_skip_relocation, ventura:       "8efe18a524dd30548bd96d66d896e301b5a04bb789d7f9921355614509129d58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17a4df459ea2d44454c938fd286ceeec4c9acf9c23af140492cbf0d02f4c6be5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b432caf6860ed345b258e6cad96d1c5097a7768402cb01387fa45bb143ed601"
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