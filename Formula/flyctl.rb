class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.7",
      revision: "eda66fa4e243e5184fd4c0888f8f05b26f37541d"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01420517ea99a39786ab73d297df668e259fed3dd030fe3c413289a0dcece01b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01420517ea99a39786ab73d297df668e259fed3dd030fe3c413289a0dcece01b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01420517ea99a39786ab73d297df668e259fed3dd030fe3c413289a0dcece01b"
    sha256 cellar: :any_skip_relocation, ventura:        "71444ce368b7bd9f70a681cb8338369f8650cf727481fa7a92aec02ced3709b3"
    sha256 cellar: :any_skip_relocation, monterey:       "71444ce368b7bd9f70a681cb8338369f8650cf727481fa7a92aec02ced3709b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "71444ce368b7bd9f70a681cb8338369f8650cf727481fa7a92aec02ced3709b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "025247283a8ec4feeb2380a3a7d32f0ca2e30697d0310fa919137af98a90e201"
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