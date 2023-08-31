class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.85",
      revision: "571aac05160668d9e70fc489e9d5a98893c0cc14"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7935cbbe0fdced0eba479e2f93622b8bad336b298329e66bca1e925a768b470c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7935cbbe0fdced0eba479e2f93622b8bad336b298329e66bca1e925a768b470c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7935cbbe0fdced0eba479e2f93622b8bad336b298329e66bca1e925a768b470c"
    sha256 cellar: :any_skip_relocation, ventura:        "e4de4e78adaacacd639cfba68b2e8fd73b1b5530cb978738fbb93cdfaa7ae7e1"
    sha256 cellar: :any_skip_relocation, monterey:       "e4de4e78adaacacd639cfba68b2e8fd73b1b5530cb978738fbb93cdfaa7ae7e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4de4e78adaacacd639cfba68b2e8fd73b1b5530cb978738fbb93cdfaa7ae7e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7d4ab659ebb1a6fd31d0b063544f79aee3a451c62f3a7b4e49f831acbdaf343"
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