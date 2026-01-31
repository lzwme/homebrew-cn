class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://ghfast.top/https://github.com/rusq/slackdump/archive/refs/tags/v3.1.12.tar.gz"
  sha256 "154abdca5039fd0b40bf9a0047258e2f5249ac4526c017939bb5a6cb9993787c"
  license "GPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11e1756e24dac750724adf07d0e81117123d2b6a9ff2db58815751031f3f9db0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11e1756e24dac750724adf07d0e81117123d2b6a9ff2db58815751031f3f9db0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11e1756e24dac750724adf07d0e81117123d2b6a9ff2db58815751031f3f9db0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e400eb65d980f4d9f77332ce3134ec6373405f01c7c71f1754f7419a7787f668"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e91723c17c60a84e8e7d3624736e58fdf5ea23f68d41329447058688eb30d7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e95327ca78ef38327f85178f62fcfa979369d5221284cca9cad0cb849844f4f9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/slackdump"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackdump version")

    output = shell_output("#{bin}/slackdump workspace list 2>&1", 9)
    assert_match "(User Error): no authenticated workspaces", output
  end
end