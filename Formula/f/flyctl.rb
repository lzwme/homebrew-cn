class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.111",
      revision: "063d69d54657863b215916f356fb8e98d515c9c3"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60f48aa20154afb61867e9c78b599df6e24be2002f785414c0332d937c5da199"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60f48aa20154afb61867e9c78b599df6e24be2002f785414c0332d937c5da199"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60f48aa20154afb61867e9c78b599df6e24be2002f785414c0332d937c5da199"
    sha256 cellar: :any_skip_relocation, sonoma:         "77e0fd8b14e2368c9609ee3a44f639c5beae9906695dc34f3645548db9184004"
    sha256 cellar: :any_skip_relocation, ventura:        "77e0fd8b14e2368c9609ee3a44f639c5beae9906695dc34f3645548db9184004"
    sha256 cellar: :any_skip_relocation, monterey:       "77e0fd8b14e2368c9609ee3a44f639c5beae9906695dc34f3645548db9184004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f39dc57c3ac0ce4d1df1430847f5dc4621885010a430bdb22fd968b1893f7508"
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