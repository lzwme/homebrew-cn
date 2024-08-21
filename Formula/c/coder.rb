class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.13.5.tar.gz"
  sha256 "dfbdff45fac59a25cccc4627112c2cd8448140f2b491b1340634f1a25e2ebb3b"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b50594284da8a4c935a8326f479e1a20a124a9fc5e1dbbe2f34632ba647cfddf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31e6a0db5feb1d2f5220c33efb87387a2c0ec2d826cec088fc9fdfe80893f424"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "934001443cf70418c22d09503b34c505593d905523a2ff353f8da7c3baa3d2dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a238ac22fd87c62ed4019b52e854a38f179c8153dd27034bed25cf315497dd2"
    sha256 cellar: :any_skip_relocation, ventura:        "640411a3aaaca7ce5e0a0cf1b7fd2cceb51324b029dcadd160fecbd0dd51546a"
    sha256 cellar: :any_skip_relocation, monterey:       "34630b72cceeb1440d739599ff6f1cfa21d035917b7ecc6379b935ad124d10cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "765afba4eb89de00ee728c8500af8d342e6066a2a079388a9ce59d6325b8d804"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comcodercoderv2buildinfo.tag=#{version}
      -X github.comcodercoderv2buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "slim", ".cmdcoder"
  end

  test do
    version_output = shell_output("#{bin}coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}coder netcheck 2>&1", 1)
  end
end