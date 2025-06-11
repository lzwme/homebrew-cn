class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.142",
      revision: "d62f7d0d3e2b0a20f044dac4ce6a7bfd53438772"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "812a381a391ed614944aa3da18f775662a173d98f4b64df993b05347047c0c71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "812a381a391ed614944aa3da18f775662a173d98f4b64df993b05347047c0c71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "812a381a391ed614944aa3da18f775662a173d98f4b64df993b05347047c0c71"
    sha256 cellar: :any_skip_relocation, sonoma:        "f38cf3e119394d09b5bce49b8d62026ac13388f1d8caafafdef553d24a3cdda6"
    sha256 cellar: :any_skip_relocation, ventura:       "f38cf3e119394d09b5bce49b8d62026ac13388f1d8caafafdef553d24a3cdda6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "310b41c4a4431b7f20cbffbdb5a2ac69d31fa16614041977fb8429817b2543e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bb7eb1091a8a7c869d04659b68d20e6959769ca1912a8c28bafff85650e1326"
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