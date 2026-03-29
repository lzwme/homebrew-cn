class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://ghfast.top/https://github.com/rusq/slackdump/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "fd12844acfe421a246c136751fde5bc3364dfd503300b9d24f5ca93d21eb115c"
  license "AGPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eee14dc511c1bbb764b178d413c32e43d7314f22bc3ff53ce0c62a946628fe55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eee14dc511c1bbb764b178d413c32e43d7314f22bc3ff53ce0c62a946628fe55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eee14dc511c1bbb764b178d413c32e43d7314f22bc3ff53ce0c62a946628fe55"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6d8c21d26fe4d90b478069d6b4c461deac29f5f681bbcf5e31019fb22b79854"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91e2634e07265104a5b24f271ec9810443beed5d20c1d9534bf51f4ce55bb506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b5bb4b223f80ba63a9b5b6e240fe81422171bf7c31d1a872d056393e0e98834"
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