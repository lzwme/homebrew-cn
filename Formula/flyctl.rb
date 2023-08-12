class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.76",
      revision: "eb18df0ba905e98d881b2ca1f968c19285e650bc"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb37ff9c5dfee3ca0374469f089e7a398b618921206a674923e274b63378b9a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb37ff9c5dfee3ca0374469f089e7a398b618921206a674923e274b63378b9a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb37ff9c5dfee3ca0374469f089e7a398b618921206a674923e274b63378b9a8"
    sha256 cellar: :any_skip_relocation, ventura:        "bd93259a6f85b1cb38535ca323b8236afc030594e2468912d01c496f15a305e2"
    sha256 cellar: :any_skip_relocation, monterey:       "bd93259a6f85b1cb38535ca323b8236afc030594e2468912d01c496f15a305e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd93259a6f85b1cb38535ca323b8236afc030594e2468912d01c496f15a305e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11fbf6464af1807d76954fb2d850222078e7e128e3b47f9f412514a64579d44d"
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