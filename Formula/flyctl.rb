class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.60",
      revision: "57f0443b7521c4374ea524dac74ca9ed65bfb94d"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c8a148d08f2bad4955546f128e68e63c6cb33a1c497dd79f828db61c8facfab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c8a148d08f2bad4955546f128e68e63c6cb33a1c497dd79f828db61c8facfab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c8a148d08f2bad4955546f128e68e63c6cb33a1c497dd79f828db61c8facfab"
    sha256 cellar: :any_skip_relocation, ventura:        "f6f626b847e12b5b0e914d828e9e9ce07ef9fefa1db45067d2428a9b5c4ac4e4"
    sha256 cellar: :any_skip_relocation, monterey:       "f6f626b847e12b5b0e914d828e9e9ce07ef9fefa1db45067d2428a9b5c4ac4e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6f626b847e12b5b0e914d828e9e9ce07ef9fefa1db45067d2428a9b5c4ac4e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2ede6cdc4b4ba548e0ff275e96eb7ac70636927986fa8dee1d8f9dbb414fa97"
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