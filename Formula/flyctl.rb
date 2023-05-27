class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.20",
      revision: "584174c3a5d8302bce7f65b91e4c5c2688a500fb"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b12eba879fa13f9af6bbf7327ddd990dc0bf48cd929873cacb3ac16c129eac9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b12eba879fa13f9af6bbf7327ddd990dc0bf48cd929873cacb3ac16c129eac9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b12eba879fa13f9af6bbf7327ddd990dc0bf48cd929873cacb3ac16c129eac9"
    sha256 cellar: :any_skip_relocation, ventura:        "2902b78c08c480ce4f296c0a84a09b2eafcdfbd7a0cfad0c3af4762dd49b23c7"
    sha256 cellar: :any_skip_relocation, monterey:       "2902b78c08c480ce4f296c0a84a09b2eafcdfbd7a0cfad0c3af4762dd49b23c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2902b78c08c480ce4f296c0a84a09b2eafcdfbd7a0cfad0c3af4762dd49b23c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2759b18a4b7fe14c8d2b10e107f8b17d39ce332e594e4c0998bf6fb3e803b302"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end