class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.32",
      revision: "aa76158a7717c3d5226799081435c46080ea874f"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58068a3e93757d5dad13d6aeeb075f7f0888c004d69ba544f6b3869df60f3f94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58068a3e93757d5dad13d6aeeb075f7f0888c004d69ba544f6b3869df60f3f94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58068a3e93757d5dad13d6aeeb075f7f0888c004d69ba544f6b3869df60f3f94"
    sha256 cellar: :any_skip_relocation, ventura:        "0b3ca9751067bfd7b715bb3d7cbe9fc44d7a7c8810570758a61f3ba3f6cb4ce9"
    sha256 cellar: :any_skip_relocation, monterey:       "0b3ca9751067bfd7b715bb3d7cbe9fc44d7a7c8810570758a61f3ba3f6cb4ce9"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b3ca9751067bfd7b715bb3d7cbe9fc44d7a7c8810570758a61f3ba3f6cb4ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74bf4d953963daf56e732be9caf75d7fb692656ec567f11660ee582f943115fa"
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