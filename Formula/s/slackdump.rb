class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://ghfast.top/https://github.com/rusq/slackdump/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "effaece3298bf95495596bcaff1ca0cbf68b8e81875b2082c92e852277a244ee"
  license "AGPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af9f6e430e2f19cc149dc2cf9ee53632bfdca8bda0aab4e917d27ad6c771146d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af9f6e430e2f19cc149dc2cf9ee53632bfdca8bda0aab4e917d27ad6c771146d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af9f6e430e2f19cc149dc2cf9ee53632bfdca8bda0aab4e917d27ad6c771146d"
    sha256 cellar: :any_skip_relocation, sonoma:        "87e1f1b18d9613e8fa0b4aa75410d8e03b7b6989a79ea12fbf633e062b3994ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "344bb2733a44721913a3bd7f95a77724bf27bf66ef602049a01938159557cfa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57b151045fe0a6b17ce26d58546f73cce441e40fc588e14cf5df8d3cd9885592"
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