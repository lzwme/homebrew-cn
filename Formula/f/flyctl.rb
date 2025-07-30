class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.163",
      revision: "9a7ba7f7273eb3bf820137171b16b12e15145208"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23b33152d1dc2c3746dbdd2b8deb39db9d1a2d68cdb837620ca7ffa4a135ca3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23b33152d1dc2c3746dbdd2b8deb39db9d1a2d68cdb837620ca7ffa4a135ca3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23b33152d1dc2c3746dbdd2b8deb39db9d1a2d68cdb837620ca7ffa4a135ca3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "35a1e390ff834ffed41bd86ff8692a358bf67b78f8dd3d17d31d0b69322befa1"
    sha256 cellar: :any_skip_relocation, ventura:       "35a1e390ff834ffed41bd86ff8692a358bf67b78f8dd3d17d31d0b69322befa1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec7a0e455119716fca945b381ebc3947c962e2464119334f8d575d1dfb951594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8c946dc6e16e18825dcdf7a5527bc8b7f8e0925e9c6067d2fd2a91f78d689ae"
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