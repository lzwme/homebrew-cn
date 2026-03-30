class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://ghfast.top/https://github.com/rusq/slackdump/archive/refs/tags/v4.1.2.tar.gz"
  sha256 "b2ffb53adba936537b6e84355a832dd57065d529f361752894702c403d29dbfe"
  license "AGPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "577033d097050754a51170242f19efb708ebfcc0264828976137fc883bb8cd0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "577033d097050754a51170242f19efb708ebfcc0264828976137fc883bb8cd0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "577033d097050754a51170242f19efb708ebfcc0264828976137fc883bb8cd0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c4653768f25240b93c9e4332d982ef9d946f1d3fb014cb4155dde9ea70630f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b717c1d08dc43760aea9249e25676b67735e73f3dff0af018c8e040a518d70f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e0e5589848887392fa5da4e62af8ed2d0b5f2fc73571859d9e2643d04c82e2c"
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