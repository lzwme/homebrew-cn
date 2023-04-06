class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.507",
      revision: "f92741d971911c1f542265c5e9dd696611e6e2c1"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcddc61f911895bf2507c41a55a2901423ea6b88f064fb8cf83ded7022604cf9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcddc61f911895bf2507c41a55a2901423ea6b88f064fb8cf83ded7022604cf9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dcddc61f911895bf2507c41a55a2901423ea6b88f064fb8cf83ded7022604cf9"
    sha256 cellar: :any_skip_relocation, ventura:        "6f20dc674c5b34427266a6215bfd65afb88e6689ccf670949001eaacfcf79b15"
    sha256 cellar: :any_skip_relocation, monterey:       "6f20dc674c5b34427266a6215bfd65afb88e6689ccf670949001eaacfcf79b15"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f20dc674c5b34427266a6215bfd65afb88e6689ccf670949001eaacfcf79b15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7e92f0ab862a46fc972d0cc9cca1d34fbd8f28079558a96343d23c5bd917586"
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
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end