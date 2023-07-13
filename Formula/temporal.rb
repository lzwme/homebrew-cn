class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://ghproxy.com/https://github.com/temporalio/cli/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "6257674732ba3f63f7bea43b9ce4199948b689604671a4001538d862ade28677"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "559ec36ebdd64e44a3324512f30ff8ee13e62bedb465c88a73cd4dc5820a3df5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "559ec36ebdd64e44a3324512f30ff8ee13e62bedb465c88a73cd4dc5820a3df5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "559ec36ebdd64e44a3324512f30ff8ee13e62bedb465c88a73cd4dc5820a3df5"
    sha256 cellar: :any_skip_relocation, ventura:        "8dcc5e9a405c20297a8d3724983a920ca3b690e10dfa0b4cf7b3fd0a74a42010"
    sha256 cellar: :any_skip_relocation, monterey:       "8dcc5e9a405c20297a8d3724983a920ca3b690e10dfa0b4cf7b3fd0a74a42010"
    sha256 cellar: :any_skip_relocation, big_sur:        "8dcc5e9a405c20297a8d3724983a920ca3b690e10dfa0b4cf7b3fd0a74a42010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8678b34642d299c5c8b98f1a39c0736655450646cc7b4b341aacf80a5bb02ef3"
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