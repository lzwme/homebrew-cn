class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.33",
      revision: "d787a21fb3b1d2c99b7b6ab9ae5fabf855143240"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99954e22c1ef09c5e9274a228ea2c3d106d63e13e9e4660d01a267dc15229bb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99954e22c1ef09c5e9274a228ea2c3d106d63e13e9e4660d01a267dc15229bb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99954e22c1ef09c5e9274a228ea2c3d106d63e13e9e4660d01a267dc15229bb9"
    sha256 cellar: :any_skip_relocation, ventura:        "e7123b6420085508d5c9da24190a630adef63f088a736327e85a5b5d479327af"
    sha256 cellar: :any_skip_relocation, monterey:       "e7123b6420085508d5c9da24190a630adef63f088a736327e85a5b5d479327af"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7123b6420085508d5c9da24190a630adef63f088a736327e85a5b5d479327af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5ffb06fc6744fd4ef1044a7013c0af1bfc92adf5f7064fe2a6fe5cf764e5f69"
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