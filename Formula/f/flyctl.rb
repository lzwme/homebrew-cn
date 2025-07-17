class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.157",
      revision: "700a227b730ee81036d20a2445209b15517c6c2f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82c7c52832ffae116e5f08e49ed4991f7f5fc945e754df9938da6ba2ff5cf6ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82c7c52832ffae116e5f08e49ed4991f7f5fc945e754df9938da6ba2ff5cf6ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82c7c52832ffae116e5f08e49ed4991f7f5fc945e754df9938da6ba2ff5cf6ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "09e14d882af231185087f64a85e0c9a672f92e1a1ffe91c2d82bb9d11ca074bd"
    sha256 cellar: :any_skip_relocation, ventura:       "09e14d882af231185087f64a85e0c9a672f92e1a1ffe91c2d82bb9d11ca074bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28acd20254dd2e2091c83f0eff970f0dbdeb23c932ac65fedc865de332652994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "664b92c117dfd42de3a25d7e03193928385359a6f4dedd2c8cb5823a3dd88e1c"
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