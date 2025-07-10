class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.153",
      revision: "cec117a93d23bac03cc8fa75e35c6d63da65fa0b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d0c43e298e371861e2746488b2b09c898a3cf026069b8819acb40f434660b66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d0c43e298e371861e2746488b2b09c898a3cf026069b8819acb40f434660b66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d0c43e298e371861e2746488b2b09c898a3cf026069b8819acb40f434660b66"
    sha256 cellar: :any_skip_relocation, sonoma:        "b141abca175dde06709152b6d6ed9de5a6724d5901ed4e94920f3cf440620c42"
    sha256 cellar: :any_skip_relocation, ventura:       "b141abca175dde06709152b6d6ed9de5a6724d5901ed4e94920f3cf440620c42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2803a307e2b67ebbfb8cd949a3cc868cf205631c4c865aa7e3147abd1d898ff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be51fea8b64b3638bcabdcb6d57a231ac50c4a4654de76dd6d14a061d08b44ad"
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