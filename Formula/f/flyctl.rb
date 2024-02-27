class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.10",
      revision: "2c5984735330d28d1b5506a23c2a43302c72bffb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a6163744454819c99374be6e8958236f1e32768dea35f2f35184f79f020e47c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a6163744454819c99374be6e8958236f1e32768dea35f2f35184f79f020e47c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a6163744454819c99374be6e8958236f1e32768dea35f2f35184f79f020e47c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e716d0bfc2821d2edfe0e456a61c833ba70135de437f45b9872bc574db3ffa9c"
    sha256 cellar: :any_skip_relocation, ventura:        "e716d0bfc2821d2edfe0e456a61c833ba70135de437f45b9872bc574db3ffa9c"
    sha256 cellar: :any_skip_relocation, monterey:       "e716d0bfc2821d2edfe0e456a61c833ba70135de437f45b9872bc574db3ffa9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4863a4dc407ee7a080df104861fef19414d967b8dd0052399b8d8f9fa774d0d3"
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