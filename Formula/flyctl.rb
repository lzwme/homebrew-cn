class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.548",
      revision: "2b7d870f64a34bc13e09c580b1d78b9d3f4d66e1"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1963b1b4e2930c677b6508b022d30bfa66cd79e8af6d1029960ccc2862df57e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1963b1b4e2930c677b6508b022d30bfa66cd79e8af6d1029960ccc2862df57e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1963b1b4e2930c677b6508b022d30bfa66cd79e8af6d1029960ccc2862df57e"
    sha256 cellar: :any_skip_relocation, ventura:        "dce78acc342bf5692b4f8c374339d934359341bba2c99e8dc6149ce3a3572757"
    sha256 cellar: :any_skip_relocation, monterey:       "dce78acc342bf5692b4f8c374339d934359341bba2c99e8dc6149ce3a3572757"
    sha256 cellar: :any_skip_relocation, big_sur:        "dce78acc342bf5692b4f8c374339d934359341bba2c99e8dc6149ce3a3572757"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b3e28558c4fbc3145040b9b99479a21596b0ff6b25d3d8d855a5aadc759905f"
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