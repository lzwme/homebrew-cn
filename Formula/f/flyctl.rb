class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.159",
      revision: "8cbd951ac6f2addadf902debfcfc52b34b3653bd"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75661d929a1b44632ae21300475e65bc6f97fb9733ef761e28a72eab42ed5b4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75661d929a1b44632ae21300475e65bc6f97fb9733ef761e28a72eab42ed5b4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75661d929a1b44632ae21300475e65bc6f97fb9733ef761e28a72eab42ed5b4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3f6acc6351dd46c439ecd896c0eb4b0787ee4045c004ace93dba5add614b9be"
    sha256 cellar: :any_skip_relocation, ventura:       "d3f6acc6351dd46c439ecd896c0eb4b0787ee4045c004ace93dba5add614b9be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96ff54d3467e63ccac2b8512b1e2c7eb9b0f82ef191703c0c303f056d644d603"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b343ca8a0b370677f5bda7301e1f3d62bce2d4d00a5c23acf9660709a0a99179"
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
    system "go", "build", *std_go_args(ldflags:, tags: "production")

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
    generate_completions_from_executable(bin/"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end