class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.2",
      revision: "3eb4638dc230596e8c1930411cdab921ab70802b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9f91e83530ae133ece0c6f3f0c6f259e23acd01e0d271c2f3762cd7933654035"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f91e83530ae133ece0c6f3f0c6f259e23acd01e0d271c2f3762cd7933654035"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f91e83530ae133ece0c6f3f0c6f259e23acd01e0d271c2f3762cd7933654035"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f91e83530ae133ece0c6f3f0c6f259e23acd01e0d271c2f3762cd7933654035"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e2f3d4cfca4e13f14839c34a28c125e604951d5740b91e783b05032eeceec26"
    sha256 cellar: :any_skip_relocation, ventura:        "2e2f3d4cfca4e13f14839c34a28c125e604951d5740b91e783b05032eeceec26"
    sha256 cellar: :any_skip_relocation, monterey:       "2e2f3d4cfca4e13f14839c34a28c125e604951d5740b91e783b05032eeceec26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1569cd61ade73257b4eabbcb01ba83398cc027fa731cd564196a6238b5ab5543"
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