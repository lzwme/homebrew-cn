class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.41",
      revision: "192beb743147762e87f9e8c35f2cc6baa837fd12"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08ff757692b3c1b61a83d9b748b9b89cf30313c8bf0b54f0ebe936322dd90a1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08ff757692b3c1b61a83d9b748b9b89cf30313c8bf0b54f0ebe936322dd90a1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08ff757692b3c1b61a83d9b748b9b89cf30313c8bf0b54f0ebe936322dd90a1b"
    sha256 cellar: :any_skip_relocation, ventura:        "7559821e7b02ecc97da59f5849eb9fdc87a7371cf5903f9103e0beb7d810a3af"
    sha256 cellar: :any_skip_relocation, monterey:       "7559821e7b02ecc97da59f5849eb9fdc87a7371cf5903f9103e0beb7d810a3af"
    sha256 cellar: :any_skip_relocation, big_sur:        "7559821e7b02ecc97da59f5849eb9fdc87a7371cf5903f9103e0beb7d810a3af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09481c8251e6446a8960c86b4775b54343c2f41799f84e011e4c715cdca5f02e"
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