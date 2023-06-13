class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.34",
      revision: "41e0a9e0f9583bc3a67faa22f70bd60a22133415"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29e80cbc44cb85653e826371f66bfabc80b35fe40875c0498324e7cd272f9bfc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29e80cbc44cb85653e826371f66bfabc80b35fe40875c0498324e7cd272f9bfc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29e80cbc44cb85653e826371f66bfabc80b35fe40875c0498324e7cd272f9bfc"
    sha256 cellar: :any_skip_relocation, ventura:        "1c5aab0bb1463a8c1de1d568fc9486c3735140736099f39d701943ee711e0584"
    sha256 cellar: :any_skip_relocation, monterey:       "1c5aab0bb1463a8c1de1d568fc9486c3735140736099f39d701943ee711e0584"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c5aab0bb1463a8c1de1d568fc9486c3735140736099f39d701943ee711e0584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f604d849c03f2a5f23f7fc4ff3486496db2db160bd9fe4d70b7f86b858a10327"
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