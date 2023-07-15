class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.58",
      revision: "82ebecb2bf83647d20c0e11e51272418f40a9b2c"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "349b0c01eea09a1f2b7c6db9b2449e6259dbeeef7943b2f6fedd2fbb518a0391"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "349b0c01eea09a1f2b7c6db9b2449e6259dbeeef7943b2f6fedd2fbb518a0391"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "349b0c01eea09a1f2b7c6db9b2449e6259dbeeef7943b2f6fedd2fbb518a0391"
    sha256 cellar: :any_skip_relocation, ventura:        "4d6f7bf10627e239983448525a927e664a559889217c879bdd812e5b95c6ec52"
    sha256 cellar: :any_skip_relocation, monterey:       "4d6f7bf10627e239983448525a927e664a559889217c879bdd812e5b95c6ec52"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d6f7bf10627e239983448525a927e664a559889217c879bdd812e5b95c6ec52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa36a4a47e0633087cb32ec22a60a5e4328cfff15c4cffa09bd16b2b5e6cb37f"
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