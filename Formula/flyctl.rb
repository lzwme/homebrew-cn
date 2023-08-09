class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.73",
      revision: "0216552968cfae7a74a2dd384d36f6e0a7951e06"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39373f655aa9022f2373200067840dd78d83fc20edf89a53db793eb590688e39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39373f655aa9022f2373200067840dd78d83fc20edf89a53db793eb590688e39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39373f655aa9022f2373200067840dd78d83fc20edf89a53db793eb590688e39"
    sha256 cellar: :any_skip_relocation, ventura:        "0a52dc991760670ebb11f1d10a3374aab7ea9cdb11a34e749f4d19455846a61a"
    sha256 cellar: :any_skip_relocation, monterey:       "0a52dc991760670ebb11f1d10a3374aab7ea9cdb11a34e749f4d19455846a61a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a52dc991760670ebb11f1d10a3374aab7ea9cdb11a34e749f4d19455846a61a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c4bef8b6ea3d853be1236742c257c419798a0c57263c173d7154163e0eff0a5"
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