class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.24",
      revision: "86409d36fda482b419410a4af3113d12537a06d7"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb236f5b30329e0201cefa91d2dd98f347671022bd20035b6d403872f72e7e73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb236f5b30329e0201cefa91d2dd98f347671022bd20035b6d403872f72e7e73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb236f5b30329e0201cefa91d2dd98f347671022bd20035b6d403872f72e7e73"
    sha256 cellar: :any_skip_relocation, ventura:        "c0b850ac3995daa70507c790ca526e40ab1efc4768ce6754a88b86d790ef850d"
    sha256 cellar: :any_skip_relocation, monterey:       "c0b850ac3995daa70507c790ca526e40ab1efc4768ce6754a88b86d790ef850d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0b850ac3995daa70507c790ca526e40ab1efc4768ce6754a88b86d790ef850d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24e19a77a1b6db2dc33ae58c2e8d515be40286a9ce48b23324d0f02ede876db8"
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