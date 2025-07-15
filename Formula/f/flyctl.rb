class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.155",
      revision: "0ce643e737e928c6065bcb58083c5e1cb0206e5a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0752ffa9b1f8656517d530364d28b8dc2872c36dc618a94625a9dd66f99075b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0752ffa9b1f8656517d530364d28b8dc2872c36dc618a94625a9dd66f99075b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0752ffa9b1f8656517d530364d28b8dc2872c36dc618a94625a9dd66f99075b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "050c9247ae3bc9c9d63adccd088e39b36de5e2b8c042049d216bbc63fcd278d7"
    sha256 cellar: :any_skip_relocation, ventura:       "050c9247ae3bc9c9d63adccd088e39b36de5e2b8c042049d216bbc63fcd278d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae497ed07e5cd07d0173cde0b7766081ff9c1b2cb8b876a587151f228329656d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "639282b52f38b5045a024d65afcb5b02bce79efdd470e69412fa591d4b2d0b17"
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