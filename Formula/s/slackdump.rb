class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://ghfast.top/https://github.com/rusq/slackdump/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "8af0513f50276aafa4abbe3d76949ef56d27bd6256b499361f536e2a8c7d1212"
  license "AGPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cfea73851278db77f9586276e8669837c00a660bbc0ce016e31327d7c882e3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cfea73851278db77f9586276e8669837c00a660bbc0ce016e31327d7c882e3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cfea73851278db77f9586276e8669837c00a660bbc0ce016e31327d7c882e3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f4a1d3dc2ed2c1f53bcfee756ae9f28e6452f7bec23489e36670b52f549feb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08c5ed889c8aec6dcc9498f461b722fed0431bffbe9d7cd9f29d196ba7c7b9fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53db87014378c9c72d399255fe2b1da73f66f4d1c5c88588be1ccb8e365fac24"
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