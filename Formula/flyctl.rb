class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.51",
      revision: "82d182e812f43e6d527660a3895fc5f2c611bc3b"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a326738a2ece17665f72077ff60c535d78362bd224f8767c74bcc7f42a77ecda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a326738a2ece17665f72077ff60c535d78362bd224f8767c74bcc7f42a77ecda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a326738a2ece17665f72077ff60c535d78362bd224f8767c74bcc7f42a77ecda"
    sha256 cellar: :any_skip_relocation, ventura:        "fc0a07d97ead282232d70f59fa13d5d1feb5dd34bce0ff5d7e4a5ec62a04d6cf"
    sha256 cellar: :any_skip_relocation, monterey:       "fc0a07d97ead282232d70f59fa13d5d1feb5dd34bce0ff5d7e4a5ec62a04d6cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc0a07d97ead282232d70f59fa13d5d1feb5dd34bce0ff5d7e4a5ec62a04d6cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea84b3e286d07efe643e9552e30856593d257ed87831a0d478ff56e740db5e13"
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