class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://ghfast.top/https://github.com/rusq/slackdump/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "1790327a065a8b51d5bf051c1e6aa9b66f2518bf64450575b513893489a13809"
  license "AGPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38dd699e7c668526b11681c32a7b75f840e56e9cfdca3e3e977c8efbd1cecafc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38dd699e7c668526b11681c32a7b75f840e56e9cfdca3e3e977c8efbd1cecafc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38dd699e7c668526b11681c32a7b75f840e56e9cfdca3e3e977c8efbd1cecafc"
    sha256 cellar: :any_skip_relocation, sonoma:        "41f442c739aed94a30baa61b542b53204e62ead0dfd7083b91d0516a29660ad5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64499d2c19e9b56805d428de10043428b5384c45b942262bb322989774f4d2c8"
    sha256 cellar: :any,                 x86_64_linux:  "9b33b26608e32046cc6897cef066296ec9243cce1e535368f61c703a162853d3"
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