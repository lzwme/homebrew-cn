class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://ghfast.top/https://github.com/rusq/slackdump/archive/refs/tags/v4.5.2.tar.gz"
  sha256 "97a4ef100c9113c540e4e5b5ad1c023d9acc2a009f994269f59e347dd6f93a00"
  license "AGPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ce23dce91ba52f7188056613949137918e63262781aa07b61d4228a9c1c1bd78"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ce23dce91ba52f7188056613949137918e63262781aa07b61d4228a9c1c1bd78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ce23dce91ba52f7188056613949137918e63262781aa07b61d4228a9c1c1bd78"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e7ddd164948efc8bfc7fce5a0df17889d1079cc53569495e179b81e12a23fbfb"
    sha256 cellar: :any,                 x86_64_linux:      "884a6d1b82fe8734e4c430432f5bb8b14105e378bcff58c50c8ae19afd965723"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/slackdump"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackdump version")

    output = shell_output("#{bin}/slackdump workspace list 2>&1", 9)
    assert_match "(User Error): no authenticated workspaces", output
  end
end