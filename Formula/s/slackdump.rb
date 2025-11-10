class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://ghfast.top/https://github.com/rusq/slackdump/archive/refs/tags/v3.1.9.tar.gz"
  sha256 "c5b4a96de0325ce1cc215b5bf2cff87b0c11e37d5bcd3d152ab28c7a7fe64e3c"
  license "GPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66a120a4e8075e6be90da1d1db81231633507d6de9919e1235fbc6325e19cfac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66a120a4e8075e6be90da1d1db81231633507d6de9919e1235fbc6325e19cfac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66a120a4e8075e6be90da1d1db81231633507d6de9919e1235fbc6325e19cfac"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bbbb70f166964f17d1c30ca1bc72c4e97bc163c05305cc5e54876f20105376c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b354ee80ade90fad98b6ac78e35ff05aa68e2de14210f803ca387825daeadfa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25cfeffdd168cd7a50e8ed1ceba815acf8dd981d6f8c669fe51918df215d0f9a"
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