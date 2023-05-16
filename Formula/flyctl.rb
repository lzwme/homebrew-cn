class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.4",
      revision: "a0793c875320bf13cf9457b5af08cc2bc68b3ee2"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29cf8fc6bc38a8371a0f024f7934902ef8377e5a48783b0e68dc59d478455b5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29cf8fc6bc38a8371a0f024f7934902ef8377e5a48783b0e68dc59d478455b5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29cf8fc6bc38a8371a0f024f7934902ef8377e5a48783b0e68dc59d478455b5a"
    sha256 cellar: :any_skip_relocation, ventura:        "eca822c172288ed8b7baa3d31d2b97a423c0f628287e31d635d99220a5540bcb"
    sha256 cellar: :any_skip_relocation, monterey:       "eca822c172288ed8b7baa3d31d2b97a423c0f628287e31d635d99220a5540bcb"
    sha256 cellar: :any_skip_relocation, big_sur:        "eca822c172288ed8b7baa3d31d2b97a423c0f628287e31d635d99220a5540bcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7fb275deb7008f395d95cec25618960ecc0fec49459061be5a751b55166eaa0"
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