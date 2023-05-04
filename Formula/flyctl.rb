class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.552",
      revision: "159d1b0419dff73e23a83fcf3dae86975aff89d3"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a78635fbecfb379e0bc89c2be461982aa15226bdc637f1269dd987a9330f6c24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a78635fbecfb379e0bc89c2be461982aa15226bdc637f1269dd987a9330f6c24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a78635fbecfb379e0bc89c2be461982aa15226bdc637f1269dd987a9330f6c24"
    sha256 cellar: :any_skip_relocation, ventura:        "49c416b886164d6b4b5dfd9148fb0de544f07ae1d55aace743a0604e927292a8"
    sha256 cellar: :any_skip_relocation, monterey:       "49c416b886164d6b4b5dfd9148fb0de544f07ae1d55aace743a0604e927292a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "49c416b886164d6b4b5dfd9148fb0de544f07ae1d55aace743a0604e927292a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37c61b0b7fb8420918c459c6a295e30e65b81ca87a794f716b0e603f01dde11c"
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