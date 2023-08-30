class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.84",
      revision: "5735a8b979ebc938c74832c3edd52c509abaa7eb"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9d4528d152607b3d46f788e4681da5fc69e7f7c30b652e15303d845022b69ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9d4528d152607b3d46f788e4681da5fc69e7f7c30b652e15303d845022b69ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9d4528d152607b3d46f788e4681da5fc69e7f7c30b652e15303d845022b69ce"
    sha256 cellar: :any_skip_relocation, ventura:        "d9b282e4b70459a547989762d0f82f73248169cee9a18f98107aa625d9407501"
    sha256 cellar: :any_skip_relocation, monterey:       "d9b282e4b70459a547989762d0f82f73248169cee9a18f98107aa625d9407501"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9b282e4b70459a547989762d0f82f73248169cee9a18f98107aa625d9407501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "796c75fe8e93403417fe36f9a5927c54b267764bf9dbef57771192e12b79dbf9"
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