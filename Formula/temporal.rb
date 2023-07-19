class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://ghproxy.com/https://github.com/temporalio/cli/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "19cc20ae3272b81ef75936e7df767c93e0b514aa1803b03655e683a066cccc01"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c464fe04b4edcc6922d88f91365be9c29470efe702235073d60b26099bca4523"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c464fe04b4edcc6922d88f91365be9c29470efe702235073d60b26099bca4523"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c464fe04b4edcc6922d88f91365be9c29470efe702235073d60b26099bca4523"
    sha256 cellar: :any_skip_relocation, ventura:        "dec6a089f6e67614e701bda249388a780ccbcaacea4610648034892018371506"
    sha256 cellar: :any_skip_relocation, monterey:       "dec6a089f6e67614e701bda249388a780ccbcaacea4610648034892018371506"
    sha256 cellar: :any_skip_relocation, big_sur:        "dec6a089f6e67614e701bda249388a780ccbcaacea4610648034892018371506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "956a4c4d1d547f8fe047cc0474db7ac47f80002d580712783b4aa9ffde6dcefe"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/temporalio/cli/headers.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/temporal"
  end

  test do
    run_output = shell_output("#{bin}/temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end