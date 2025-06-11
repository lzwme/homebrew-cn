class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https:github.comrusqslackdump"
  url "https:github.comrusqslackdumparchiverefstagsv3.1.4.tar.gz"
  sha256 "7bc0c9eacc444cb135f8f27b33596a77379ae9ee1230f532bf9b24770a1926e9"
  license "GPL-3.0-only"
  head "https:github.comrusqslackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52a150a46905f7929e15ffa102478db25179a70fa9e311b2a347fee632ed2b6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52a150a46905f7929e15ffa102478db25179a70fa9e311b2a347fee632ed2b6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52a150a46905f7929e15ffa102478db25179a70fa9e311b2a347fee632ed2b6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bccafeef938cca55a8672481deab416bc3ad0644e16b6fafda0b51c8e4795b4d"
    sha256 cellar: :any_skip_relocation, ventura:       "bccafeef938cca55a8672481deab416bc3ad0644e16b6fafda0b51c8e4795b4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e0d1eaadd752299b3d495dfe9a84bce71571c6379aad8ec3e8b477a8acdf715"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), ".cmdslackdump"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}slackdump version")

    output = shell_output("#{bin}slackdump workspace list 2>&1", 9)
    assert_match "(User Error): no authenticated workspaces", output
  end
end