class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.36",
      revision: "e2d6ef34c6fb5a6c1274e8986775bc0c40242621"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65608a5f08a9308314833c9c95e6128d42e023baea4102a44ba6ae632b450b80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65608a5f08a9308314833c9c95e6128d42e023baea4102a44ba6ae632b450b80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65608a5f08a9308314833c9c95e6128d42e023baea4102a44ba6ae632b450b80"
    sha256 cellar: :any_skip_relocation, ventura:        "355ec74c48d485d0144f0418840099e00ddd5b89bbc7befaf47355633ad0d47b"
    sha256 cellar: :any_skip_relocation, monterey:       "355ec74c48d485d0144f0418840099e00ddd5b89bbc7befaf47355633ad0d47b"
    sha256 cellar: :any_skip_relocation, big_sur:        "355ec74c48d485d0144f0418840099e00ddd5b89bbc7befaf47355633ad0d47b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc3a2ceb16832c25d4267b67056cb9eee2cd3615e60b956dd35d1f43ec6d2d70"
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