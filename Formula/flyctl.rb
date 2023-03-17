class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.492",
      revision: "703500145f7fed002f316e800edbb172f3425716"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "caea625c879de461ef079e5449188f4178e8c2cbbd008d3345535a1be7902051"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caea625c879de461ef079e5449188f4178e8c2cbbd008d3345535a1be7902051"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "caea625c879de461ef079e5449188f4178e8c2cbbd008d3345535a1be7902051"
    sha256 cellar: :any_skip_relocation, ventura:        "1dd6ce1a6aeb01bfe65fb8ca447d5b87b4e4a869d0f0cd8c1a06408f4b527806"
    sha256 cellar: :any_skip_relocation, monterey:       "1dd6ce1a6aeb01bfe65fb8ca447d5b87b4e4a869d0f0cd8c1a06408f4b527806"
    sha256 cellar: :any_skip_relocation, big_sur:        "1dd6ce1a6aeb01bfe65fb8ca447d5b87b4e4a869d0f0cd8c1a06408f4b527806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8ce7310809b2d4b4097af68e74c6844d63ffe1c1a7a35fd6e89e4b11acf5b92"
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