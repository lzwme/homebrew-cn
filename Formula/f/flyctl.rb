class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.73",
      revision: "0048705a417f438cb1126ebad5f4b70194c5aed3"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a5d59fb77f95095610885d8130d957fab6327cdc09ce0595cf5e5e2f771640e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a5d59fb77f95095610885d8130d957fab6327cdc09ce0595cf5e5e2f771640e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a5d59fb77f95095610885d8130d957fab6327cdc09ce0595cf5e5e2f771640e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0bff23164133bf7db032fe249f2cb6f3220502aa9f52c5cd44a37ce3baa55bb2"
    sha256 cellar: :any_skip_relocation, ventura:        "0bff23164133bf7db032fe249f2cb6f3220502aa9f52c5cd44a37ce3baa55bb2"
    sha256 cellar: :any_skip_relocation, monterey:       "0bff23164133bf7db032fe249f2cb6f3220502aa9f52c5cd44a37ce3baa55bb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1e32ae7f67046ea4cc09153eaebfdcddc43d4c6d2e2e6ea64f24817358406e5"
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