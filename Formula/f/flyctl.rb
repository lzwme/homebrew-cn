class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.120",
      revision: "437e9fa9cb1a3046953f9f5a88cdc5784352f18a"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af7ff3f610e98f76f1fe4113ed700c3e11d232f0a2645bb2e78d47d2a958ddb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af7ff3f610e98f76f1fe4113ed700c3e11d232f0a2645bb2e78d47d2a958ddb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af7ff3f610e98f76f1fe4113ed700c3e11d232f0a2645bb2e78d47d2a958ddb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "1825d829ad7f54cda61c5afbe02d8784c1038a5e654673bd8ec2d58413ddd32d"
    sha256 cellar: :any_skip_relocation, ventura:        "1825d829ad7f54cda61c5afbe02d8784c1038a5e654673bd8ec2d58413ddd32d"
    sha256 cellar: :any_skip_relocation, monterey:       "1825d829ad7f54cda61c5afbe02d8784c1038a5e654673bd8ec2d58413ddd32d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7d418f9f70eab0d91a27d01bc6885dd95c6f540a57b7156206ffd322a284f8e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end