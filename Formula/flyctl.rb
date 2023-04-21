class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.531",
      revision: "43d99f535a25a54f39b3f46aca8be140a07b602f"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f950b256f3688b4939f1af17fcb445cc73d258b44083254da482ef49f15e2b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f950b256f3688b4939f1af17fcb445cc73d258b44083254da482ef49f15e2b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f950b256f3688b4939f1af17fcb445cc73d258b44083254da482ef49f15e2b7"
    sha256 cellar: :any_skip_relocation, ventura:        "ed512ba5c50f9ffb4b690f52457c9332fc6be5c89f1f4d0798097d7cc3202920"
    sha256 cellar: :any_skip_relocation, monterey:       "ed512ba5c50f9ffb4b690f52457c9332fc6be5c89f1f4d0798097d7cc3202920"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed512ba5c50f9ffb4b690f52457c9332fc6be5c89f1f4d0798097d7cc3202920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "183b4e3c0cceb2a724cdfe706a3146e8da397131ca39375dd52c0d49e1a409a6"
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