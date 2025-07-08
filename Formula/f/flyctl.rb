class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.151",
      revision: "f260d6c6449a4b082c47ceffc2c5e111cef4e66f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9dca738c3057f6476a042901aeafaa973df52d748c4993bc39e59cea607ed3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9dca738c3057f6476a042901aeafaa973df52d748c4993bc39e59cea607ed3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9dca738c3057f6476a042901aeafaa973df52d748c4993bc39e59cea607ed3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e16a20f4871253cf4302e46bc80a3be19c96a625ce3637b559ebba914dfa3c3"
    sha256 cellar: :any_skip_relocation, ventura:       "9e16a20f4871253cf4302e46bc80a3be19c96a625ce3637b559ebba914dfa3c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c65b75bab2388f73acd3d3fff5b984ba4e6c155075983521637bf49bc4d98a0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b21e3bf990117c27f01ef8a76e7eba1a3ec48a95c5a040e1569231ba31767f4"
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