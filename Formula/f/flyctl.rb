class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.81",
      revision: "adc9a058e8d6421c6321e14dee389594f8ddcf2b"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7571bb536092779bff89f53df619da8921375e94f2bd5794e1ae6cb572f3f87d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7571bb536092779bff89f53df619da8921375e94f2bd5794e1ae6cb572f3f87d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7571bb536092779bff89f53df619da8921375e94f2bd5794e1ae6cb572f3f87d"
    sha256 cellar: :any_skip_relocation, ventura:        "e49488c4c9ba3bb5151af00c0e69beec0fe51c09d7cbe0637212ce5a60e0a92c"
    sha256 cellar: :any_skip_relocation, monterey:       "e49488c4c9ba3bb5151af00c0e69beec0fe51c09d7cbe0637212ce5a60e0a92c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e49488c4c9ba3bb5151af00c0e69beec0fe51c09d7cbe0637212ce5a60e0a92c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec79790c3d31d45a5e421e12a58b5b486c8898d705fd50a2513344329a8b23fe"
  end

  # go 1.21.0 support bug report, https://github.com/superfly/flyctl/issues/2688
  depends_on "go@1.20" => :build

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