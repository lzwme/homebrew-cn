class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https:github.comrusqslackdump"
  url "https:github.comrusqslackdumparchiverefstagsv3.0.4.tar.gz"
  sha256 "d06b4a468dc5bb3fc7488a4777017a1290bd75e5489b8519a2d5dcaf75b90fe8"
  license "GPL-3.0-only"
  head "https:github.comrusqslackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7d5e2825d936b35dd0390fad5cff213d3c2bdbcf7c1305915ecc7db10e3202b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7d5e2825d936b35dd0390fad5cff213d3c2bdbcf7c1305915ecc7db10e3202b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7d5e2825d936b35dd0390fad5cff213d3c2bdbcf7c1305915ecc7db10e3202b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f262b7e17c399ecb53a481ac0a1c46b4106f193499c9b91847cfba9d38fe0559"
    sha256 cellar: :any_skip_relocation, ventura:       "f262b7e17c399ecb53a481ac0a1c46b4106f193499c9b91847cfba9d38fe0559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6ee0881ddfbd29cd9bd2e56ea2da4402b686d7766919aa3094223a897b5b8f6"
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
    assert_match version.to_s, shell_output("#{bin}slackdump version")

    output = shell_output("#{bin}slackdump workspace list 2>&1", 9)
    assert_match "ERROR 009 (User Error): no authenticated workspaces", output
  end
end