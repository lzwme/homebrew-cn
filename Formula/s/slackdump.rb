class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https:github.comrusqslackdump"
  url "https:github.comrusqslackdumparchiverefstagsv3.1.5.tar.gz"
  sha256 "86339399bc37253a77bccf13bd7f61d82bb437781489a0745664af95fc5c70b1"
  license "GPL-3.0-only"
  head "https:github.comrusqslackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ee39eb8525506ab19e3b2de8b4a2f069b625248f48219e84468066ada4e5f01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ee39eb8525506ab19e3b2de8b4a2f069b625248f48219e84468066ada4e5f01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ee39eb8525506ab19e3b2de8b4a2f069b625248f48219e84468066ada4e5f01"
    sha256 cellar: :any_skip_relocation, sonoma:        "2efd7425f26f73e8b4c8397cedfb3c9e928b81caf3d8490554c22656d442e0b1"
    sha256 cellar: :any_skip_relocation, ventura:       "2efd7425f26f73e8b4c8397cedfb3c9e928b81caf3d8490554c22656d442e0b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a02d208979b88a73b1dbec08123b3bcc8985dafd45ddefe974cd6f111c3847a"
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