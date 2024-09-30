class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.12",
      revision: "925283cf4f58fa9f5e2376e5d6dfeead98043376"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0354e1ccb02e1b30e649912627a38d21c00360557940c8c4c8bdac53878927fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0354e1ccb02e1b30e649912627a38d21c00360557940c8c4c8bdac53878927fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0354e1ccb02e1b30e649912627a38d21c00360557940c8c4c8bdac53878927fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "014cbddfc0ee4e98ee1a36c6816e6310a2426aabc96c7349c788e969f0cbdb2b"
    sha256 cellar: :any_skip_relocation, ventura:       "014cbddfc0ee4e98ee1a36c6816e6310a2426aabc96c7349c788e969f0cbdb2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e2a518f3d151b8a3d6606fc691e3d3a904c4cd9670e0c19a672092de23c380d"
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