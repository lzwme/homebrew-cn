class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.0",
      revision: "f39689b8d3cfd0590129b42b0a68e510d5d20c43"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a468153fa49e842abb7db30661b27baa543e0091bc5d2c2450c8a03a1a8b2de8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a468153fa49e842abb7db30661b27baa543e0091bc5d2c2450c8a03a1a8b2de8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a468153fa49e842abb7db30661b27baa543e0091bc5d2c2450c8a03a1a8b2de8"
    sha256 cellar: :any_skip_relocation, ventura:        "4f9ae29043e320da3e3701d627d379fdbdcb3078d7caa7fa97a7d6794edf7b47"
    sha256 cellar: :any_skip_relocation, monterey:       "4f9ae29043e320da3e3701d627d379fdbdcb3078d7caa7fa97a7d6794edf7b47"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f9ae29043e320da3e3701d627d379fdbdcb3078d7caa7fa97a7d6794edf7b47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "077ca9e63c5cd0264e5e2bcf6197a35ab58512a05d9a04058e0825087ef49f30"
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