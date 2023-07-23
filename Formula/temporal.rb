class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://ghproxy.com/https://github.com/temporalio/cli/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "5ea3eff72e974620c39a11410264af561aab34309a2b4dfce606df05ae6b3df2"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f246c291be996769f2b4fc7bd858f27c750c40b5266eebe6d1cc79caa43603a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f246c291be996769f2b4fc7bd858f27c750c40b5266eebe6d1cc79caa43603a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f246c291be996769f2b4fc7bd858f27c750c40b5266eebe6d1cc79caa43603a0"
    sha256 cellar: :any_skip_relocation, ventura:        "98eb9966ca2a4f7663d2a0ca12bfa46340b765db2d3ff9472e040c03305d3a13"
    sha256 cellar: :any_skip_relocation, monterey:       "98eb9966ca2a4f7663d2a0ca12bfa46340b765db2d3ff9472e040c03305d3a13"
    sha256 cellar: :any_skip_relocation, big_sur:        "98eb9966ca2a4f7663d2a0ca12bfa46340b765db2d3ff9472e040c03305d3a13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84ef35850b1e088e49e06d0f08aa981ad230e049b2bdb874e7c3f221877b3bd8"
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