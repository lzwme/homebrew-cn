class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.545",
      revision: "48024a7a0d9794ab6ee1284252ffc412771c035f"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb3de2589a72533eeb67c1c9acd44e567d4ab93cf0da08c7a09d2d7b03ff9e13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb3de2589a72533eeb67c1c9acd44e567d4ab93cf0da08c7a09d2d7b03ff9e13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb3de2589a72533eeb67c1c9acd44e567d4ab93cf0da08c7a09d2d7b03ff9e13"
    sha256 cellar: :any_skip_relocation, ventura:        "53a7fc72e2c4d562971c37074b4ad6c92f012f675a7597b64f600e068dfac751"
    sha256 cellar: :any_skip_relocation, monterey:       "53a7fc72e2c4d562971c37074b4ad6c92f012f675a7597b64f600e068dfac751"
    sha256 cellar: :any_skip_relocation, big_sur:        "53a7fc72e2c4d562971c37074b4ad6c92f012f675a7597b64f600e068dfac751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31b9cabce97bd82475137db10c7362a0bad8cd0f75731acecd8a725a42b1ea6e"
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