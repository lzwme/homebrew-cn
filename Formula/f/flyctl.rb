class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.89",
      revision: "52b1f53523734cf58f416e594ebb648aeddca0f9"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61fd1ed25f1454ca797657b24bbfe0144d2484f66134a165ffd40fbbbaef65d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61fd1ed25f1454ca797657b24bbfe0144d2484f66134a165ffd40fbbbaef65d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61fd1ed25f1454ca797657b24bbfe0144d2484f66134a165ffd40fbbbaef65d7"
    sha256 cellar: :any_skip_relocation, ventura:        "34099d8226c8c6a2c77bfc50f0d7a7714f498a34432b9bdd2aaa9296bd86a5fe"
    sha256 cellar: :any_skip_relocation, monterey:       "34099d8226c8c6a2c77bfc50f0d7a7714f498a34432b9bdd2aaa9296bd86a5fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "34099d8226c8c6a2c77bfc50f0d7a7714f498a34432b9bdd2aaa9296bd86a5fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f9bbeea82c092d0857f5af0c88f4acc271123430a88e2d05ed9cc98163d1959"
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