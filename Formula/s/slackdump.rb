class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https:github.comrusqslackdump"
  url "https:github.comrusqslackdumparchiverefstagsv2.6.1.tar.gz"
  sha256 "19f4ec001a818c85836385cbe76a39aafecf86d23101f1b306459473dccb32a4"
  license "GPL-3.0-only"
  head "https:github.comrusqslackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9aa2cc1d605a3384df2551f8a74265e2847bd6684416bc8b75ce532cf1e2b67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9aa2cc1d605a3384df2551f8a74265e2847bd6684416bc8b75ce532cf1e2b67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9aa2cc1d605a3384df2551f8a74265e2847bd6684416bc8b75ce532cf1e2b67"
    sha256 cellar: :any_skip_relocation, sonoma:        "56ad57ba06cb38df7e270c99ae69e1cec62dc6dee7477e958ae59e179bc2bbc4"
    sha256 cellar: :any_skip_relocation, ventura:       "56ad57ba06cb38df7e270c99ae69e1cec62dc6dee7477e958ae59e179bc2bbc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4941b690a8ca8c9a4f84c964f7da7747facc0bd641c17f105d380110755c575c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.commit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdslackdump"
  end

  test do
    assert_match version.to_s, shell_output(bin"slackdump -V")

    assert_match "You have been logged out.", shell_output(bin"slackdump -auth-reset 2>&1")
  end
end