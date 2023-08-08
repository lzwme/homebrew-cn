class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.72",
      revision: "4c6d5720c68bc26d92f80ec3407c4c10c42fec38"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d85e07be62d093034052a81652b4769acef1cf99db19e569ff6d421f8327e6d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d85e07be62d093034052a81652b4769acef1cf99db19e569ff6d421f8327e6d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d85e07be62d093034052a81652b4769acef1cf99db19e569ff6d421f8327e6d4"
    sha256 cellar: :any_skip_relocation, ventura:        "738ba3c0c1a6970b5fba1e42134044b12e3de951f376133f77114744af9e0d87"
    sha256 cellar: :any_skip_relocation, monterey:       "738ba3c0c1a6970b5fba1e42134044b12e3de951f376133f77114744af9e0d87"
    sha256 cellar: :any_skip_relocation, big_sur:        "738ba3c0c1a6970b5fba1e42134044b12e3de951f376133f77114744af9e0d87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9f3f2c96a73c695a2959b1c95717aef9eabc6b5e87194b220f5c94c1a6fdb13"
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