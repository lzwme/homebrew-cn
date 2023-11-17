class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.126",
      revision: "4d1564748f7e44cbf72746852e224d1ab66310b9"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61fad5f8ae142f49a12e9cee7a203bea3e2348b3e782b268c6f13a933a52be02"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61fad5f8ae142f49a12e9cee7a203bea3e2348b3e782b268c6f13a933a52be02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61fad5f8ae142f49a12e9cee7a203bea3e2348b3e782b268c6f13a933a52be02"
    sha256 cellar: :any_skip_relocation, sonoma:         "2bf7bc5abf14e65428b79dbdb5e81ac23d5bf056462e1c9f4a1b06d4f5912131"
    sha256 cellar: :any_skip_relocation, ventura:        "2bf7bc5abf14e65428b79dbdb5e81ac23d5bf056462e1c9f4a1b06d4f5912131"
    sha256 cellar: :any_skip_relocation, monterey:       "2bf7bc5abf14e65428b79dbdb5e81ac23d5bf056462e1c9f4a1b06d4f5912131"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d45486a8a8ed20d24a89e4d3691bf762582a0b88260ec9139a72a34d52d678b"
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