class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.91",
      revision: "ec9362243de864edf786d177048639016c52004a"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa69645b39019daf0a03f91cbe1910243f7d76d51e5b75843a65f676ecbe71f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa69645b39019daf0a03f91cbe1910243f7d76d51e5b75843a65f676ecbe71f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa69645b39019daf0a03f91cbe1910243f7d76d51e5b75843a65f676ecbe71f3"
    sha256 cellar: :any_skip_relocation, ventura:        "6103651189f35b65d9ddb028749bfe7e56c415ab9822c8a58b5fa87e9c8276a2"
    sha256 cellar: :any_skip_relocation, monterey:       "6103651189f35b65d9ddb028749bfe7e56c415ab9822c8a58b5fa87e9c8276a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "6103651189f35b65d9ddb028749bfe7e56c415ab9822c8a58b5fa87e9c8276a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68dc01f5a294e23cc00b2a4955af408e30b5325510ed81a1cd5addfbcb4f2ee7"
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