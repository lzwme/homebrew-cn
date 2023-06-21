class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.39",
      revision: "bcddf1f7e3fbe18d19a6a071fd1a2dee998facf4"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2f678dd6ee5026cfb14c7f3f9f5dfcdb04fbe0ffd87958e98bd50a64b05bc59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2f678dd6ee5026cfb14c7f3f9f5dfcdb04fbe0ffd87958e98bd50a64b05bc59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2f678dd6ee5026cfb14c7f3f9f5dfcdb04fbe0ffd87958e98bd50a64b05bc59"
    sha256 cellar: :any_skip_relocation, ventura:        "a15abb0c8a671d1fca5b2502c9d679c026214218f7fb2e19b3b07e916caeedd5"
    sha256 cellar: :any_skip_relocation, monterey:       "a15abb0c8a671d1fca5b2502c9d679c026214218f7fb2e19b3b07e916caeedd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a15abb0c8a671d1fca5b2502c9d679c026214218f7fb2e19b3b07e916caeedd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5432175a4302c4869d0ac98b0b258643a56b1996207b2c989ed84b7e1c372a30"
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