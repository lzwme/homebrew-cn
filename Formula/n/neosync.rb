class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.44.tar.gz"
  sha256 "606d8d3b3fd8313b62b6dfad44ace26c0a2d7a983ac7517284ccd17f787ee235"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66ec2188bce7607673f29c5a7f72bcea35f8030bbd93288ebaf341db5a8c2c46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d16c3387203daac41de8fecadd0220d037ceb0c645f1a350683a527bfa093ec1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a7334041d90955a739e1a61b2063ffea65cc6e725b8ad47fb4112e548ae508f"
    sha256 cellar: :any_skip_relocation, sonoma:         "cefee08f98edd89c0debcbacdf2ca4b0422b29ceeb916a2dc1bb339fe72eae97"
    sha256 cellar: :any_skip_relocation, ventura:        "3c66e1503d45c69f7ee8175a0dc5014e34c801fd02365d2fa8019b94ccb49795"
    sha256 cellar: :any_skip_relocation, monterey:       "0be317973ebe6f158af9dfb64d7d4b1fcf6cea8f30c00f087454b5390496d2dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5c45a7a16685a35964b335bdf38c74dd2f231e00303dc5cf39d206609a03c7e"
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