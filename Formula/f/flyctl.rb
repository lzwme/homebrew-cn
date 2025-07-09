class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.152",
      revision: "73691cd8d460b0308a771eac12a6c4a70b89170e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b07b1343a124bc2e8023be72c949ff20478b345cb1aa90114af38d16ac394a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b07b1343a124bc2e8023be72c949ff20478b345cb1aa90114af38d16ac394a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b07b1343a124bc2e8023be72c949ff20478b345cb1aa90114af38d16ac394a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "babdf1051a781cbcd80db8d15b39ba76053a52bce5d77c730c90679749512d08"
    sha256 cellar: :any_skip_relocation, ventura:       "babdf1051a781cbcd80db8d15b39ba76053a52bce5d77c730c90679749512d08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f3ba4f2f4054939cdbabe4b180fb17c1596d5e288dc3f2d34150c708b9b3058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aafa866c5eb4ccd26038bed28730b59da7571211021cbc0021b850edd8305b43"
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