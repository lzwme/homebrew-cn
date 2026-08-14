class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://ghfast.top/https://github.com/rusq/slackdump/archive/refs/tags/v4.4.3.tar.gz"
  sha256 "aa3b497e0d4b2f8396291178fbe0c4c9a3dcc38b6fef125571711a16ab42465c"
  license "AGPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2160365294a3ca68330ac55c8491877534773f65dfac28d080c12133d9ed97e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2160365294a3ca68330ac55c8491877534773f65dfac28d080c12133d9ed97e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2160365294a3ca68330ac55c8491877534773f65dfac28d080c12133d9ed97e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2091401392a2d218baaa6f080dd8f2c92ba19980fa70aae404bfb877c5bad00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60d7cc9898d3a71eda2dd44076b0be7e78ae7a904415ad76adf4939293041884"
    sha256 cellar: :any,                 x86_64_linux:  "afd51eee2013c10ced31def5504f6ca16001ee9bed58945a6e13b636815a9713"
  end

  depends_on "go" => :build

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