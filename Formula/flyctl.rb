class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.513",
      revision: "de8910fd3ab683ee16688947eb009752ad188d4d"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfcec409024a14b1a29dd61fcdca86be61117d53b1dcc90a4a739bcbf3927fb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfcec409024a14b1a29dd61fcdca86be61117d53b1dcc90a4a739bcbf3927fb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfcec409024a14b1a29dd61fcdca86be61117d53b1dcc90a4a739bcbf3927fb0"
    sha256 cellar: :any_skip_relocation, ventura:        "d20e2128603f10e242f13b0cb6047de8f92cc969aff720bd16cde9b269055917"
    sha256 cellar: :any_skip_relocation, monterey:       "d20e2128603f10e242f13b0cb6047de8f92cc969aff720bd16cde9b269055917"
    sha256 cellar: :any_skip_relocation, big_sur:        "d20e2128603f10e242f13b0cb6047de8f92cc969aff720bd16cde9b269055917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d73d3f607d2c24648175dd0a66eeb0a097c4a781686c8f8d1b188627a9cb02b0"
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