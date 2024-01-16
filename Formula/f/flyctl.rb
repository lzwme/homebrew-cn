class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.1.142",
      revision: "131d9bd3fad338f9e5ab366db94b955dba0b7c50"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff5a2336b11d4826ad4d32f84c695d3f96b1988dcc0e36e2ff453ae9662a332e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff5a2336b11d4826ad4d32f84c695d3f96b1988dcc0e36e2ff453ae9662a332e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff5a2336b11d4826ad4d32f84c695d3f96b1988dcc0e36e2ff453ae9662a332e"
    sha256 cellar: :any_skip_relocation, sonoma:         "15c8139f5d1fb11c3ef77b68dad8dfcea972a378223fd088f8dc47ccaa574f20"
    sha256 cellar: :any_skip_relocation, ventura:        "15c8139f5d1fb11c3ef77b68dad8dfcea972a378223fd088f8dc47ccaa574f20"
    sha256 cellar: :any_skip_relocation, monterey:       "15c8139f5d1fb11c3ef77b68dad8dfcea972a378223fd088f8dc47ccaa574f20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "853e2fa5b23d4eaef30dfa39a64ca53ce6a02434a43c67537f9230d9de95039d"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end