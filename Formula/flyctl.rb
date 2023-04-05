class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.505",
      revision: "20a787bf36fbae494c4cf53d5a1bae37994a2bea"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "253941530e691b7b2ff812d23f2c696333072185b7db8124534d48b1df1d7b46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "253941530e691b7b2ff812d23f2c696333072185b7db8124534d48b1df1d7b46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "253941530e691b7b2ff812d23f2c696333072185b7db8124534d48b1df1d7b46"
    sha256 cellar: :any_skip_relocation, ventura:        "d82bc1ab2c88cd72ade77e1ee3125950e417bee0c97fefe1dc6820f48a1ace42"
    sha256 cellar: :any_skip_relocation, monterey:       "d82bc1ab2c88cd72ade77e1ee3125950e417bee0c97fefe1dc6820f48a1ace42"
    sha256 cellar: :any_skip_relocation, big_sur:        "d82bc1ab2c88cd72ade77e1ee3125950e417bee0c97fefe1dc6820f48a1ace42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af01ff46994cf11c25644d7d684a339aaa7adfdede9adf1bc0c3b2c73c371647"
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