class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.27",
      revision: "192d65e95e4dedb0f3422c4f70d1b1bcfaae8005"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a245463bbf600614810e363422eaad35599f4aef54e3026c2839fde4d879981c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a245463bbf600614810e363422eaad35599f4aef54e3026c2839fde4d879981c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a245463bbf600614810e363422eaad35599f4aef54e3026c2839fde4d879981c"
    sha256 cellar: :any_skip_relocation, ventura:        "f37a0c284600f6791358dcd7768a356305ea3b895c6758b62e26b053273c2b8e"
    sha256 cellar: :any_skip_relocation, monterey:       "f37a0c284600f6791358dcd7768a356305ea3b895c6758b62e26b053273c2b8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f37a0c284600f6791358dcd7768a356305ea3b895c6758b62e26b053273c2b8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2da3583b1e3ee014993f709fd3a7fa5fe8cd2d511b1cad3de0e5d289d68a9bb9"
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