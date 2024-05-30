class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.23.tar.gz"
  sha256 "2c49e51b95046e82783fedbe06d2e5e7e2ef0fe989ac727aa0c71dcc9dbaa35b"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa9636eb7469a500b91c15459095d3c84d83c91306dd71d37cad7198e3e02536"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c40217645ce38600458d8106a3b57c5cfa5b28ee208fc0076d5bbd5c99bb6118"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf9cbbc522f0047e28d44eb3cd912e8e569d0686de733352e8c0e2f515be766f"
    sha256 cellar: :any_skip_relocation, sonoma:         "29ea16189775372195493a26b183524def003146cc7c003b42f12a334d948ffc"
    sha256 cellar: :any_skip_relocation, ventura:        "2dcbc4e5a7053e2ea2aa2971c833af7120c6159af3b209aed4809c714595f52c"
    sha256 cellar: :any_skip_relocation, monterey:       "f3dc7e2ae853384a3b90cb24a897d458db6ced9480a07bdaad425df99141a719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1ba5d6f4bc08c832df7d3eb3d2837b428f27ce8cfc2dc24fdcc6c2078fdf4da"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clicmdneosync"

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end