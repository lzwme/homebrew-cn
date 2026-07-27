class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://ghfast.top/https://github.com/rusq/slackdump/archive/refs/tags/v4.4.2.tar.gz"
  sha256 "0d16e88aa52b89bfdc239469351f582768492e48491b24ed255af62f58236a53"
  license "AGPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d51d26adbd47713a664ee68de91e693423cdb18a8b91ae44d753e468f0577672"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d51d26adbd47713a664ee68de91e693423cdb18a8b91ae44d753e468f0577672"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d51d26adbd47713a664ee68de91e693423cdb18a8b91ae44d753e468f0577672"
    sha256 cellar: :any_skip_relocation, sonoma:        "886aabfbeef45ce10303e12011b28bb9c441fcb5e44d63462b7383a34a52c32d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55f753fbaeed7d29010a90eabb93f4305035f8c96ebd3d4a2ef4db3f81f055b8"
    sha256 cellar: :any,                 x86_64_linux:  "7393fb6b635683ba8555af32f38ffc6f284b68af8d4081308747d155dbaee282"
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