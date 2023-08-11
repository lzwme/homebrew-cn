class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.75",
      revision: "2ea9d6eb188101754518dfce14bff5ad7b8bd509"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9055327f23ddedeb71a27e88eeaa2df3ec509856c399bb1fb98ca6d956e4eaa6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9055327f23ddedeb71a27e88eeaa2df3ec509856c399bb1fb98ca6d956e4eaa6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9055327f23ddedeb71a27e88eeaa2df3ec509856c399bb1fb98ca6d956e4eaa6"
    sha256 cellar: :any_skip_relocation, ventura:        "0fea6550542097aee3d9b5f57f8bf3292e45b1a8b973439cba10d2e875bed277"
    sha256 cellar: :any_skip_relocation, monterey:       "0fea6550542097aee3d9b5f57f8bf3292e45b1a8b973439cba10d2e875bed277"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fea6550542097aee3d9b5f57f8bf3292e45b1a8b973439cba10d2e875bed277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "905f4da387331239e23916a4e4e4bfe29823774f940c0eb11801fe82f61f7956"
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