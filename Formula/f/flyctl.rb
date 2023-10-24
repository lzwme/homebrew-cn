class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.112",
      revision: "fb160d4fd5fd653cd1afe725121230b6cba46cff"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a70af3118319efe13b6bf87b840a3172a9b5f46e1f2539cb70a7d5eb32d8057"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a70af3118319efe13b6bf87b840a3172a9b5f46e1f2539cb70a7d5eb32d8057"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a70af3118319efe13b6bf87b840a3172a9b5f46e1f2539cb70a7d5eb32d8057"
    sha256 cellar: :any_skip_relocation, sonoma:         "8992e521a634832e6985593b495bfa32a3d657b552a3a368a7922ce7e1e95ef3"
    sha256 cellar: :any_skip_relocation, ventura:        "8992e521a634832e6985593b495bfa32a3d657b552a3a368a7922ce7e1e95ef3"
    sha256 cellar: :any_skip_relocation, monterey:       "8992e521a634832e6985593b495bfa32a3d657b552a3a368a7922ce7e1e95ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffdddf04018632e9971105ded6b6ff8bb19c1460d135d927709953316b5d1a0c"
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