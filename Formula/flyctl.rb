class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.40",
      revision: "e66f5f35e30a886c4572639197c28db58046effa"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "368e88e90471784859bfe898335931656ecb6cb7b2e3d2a696ac1101eba6148c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "368e88e90471784859bfe898335931656ecb6cb7b2e3d2a696ac1101eba6148c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "368e88e90471784859bfe898335931656ecb6cb7b2e3d2a696ac1101eba6148c"
    sha256 cellar: :any_skip_relocation, ventura:        "a64b334e6f1d2c7b92353d2965981294b9d999bc4f3b7a44d051c9bc51c48e04"
    sha256 cellar: :any_skip_relocation, monterey:       "a64b334e6f1d2c7b92353d2965981294b9d999bc4f3b7a44d051c9bc51c48e04"
    sha256 cellar: :any_skip_relocation, big_sur:        "a64b334e6f1d2c7b92353d2965981294b9d999bc4f3b7a44d051c9bc51c48e04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9d0e8055cbdf80bbdbbce2e74ed4678fe60e55ce686cc2add771c6b9f5f7894"
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