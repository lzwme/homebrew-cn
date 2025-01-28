class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.5.9.tar.gz"
  sha256 "89f8251ae5cfa203751571f945d8b72858409c4a4fc19ec8d1f4e3a03aeca8e2"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfce05191f7f10e751ade21e1516d48a409c67bbd00f2167480dc080aafd0e1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfce05191f7f10e751ade21e1516d48a409c67bbd00f2167480dc080aafd0e1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cfce05191f7f10e751ade21e1516d48a409c67bbd00f2167480dc080aafd0e1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "71a14403e3e2d34f8e1ed3a0e7855a91cbee82d11f5c1aab28c848915b2bec94"
    sha256 cellar: :any_skip_relocation, ventura:       "71a14403e3e2d34f8e1ed3a0e7855a91cbee82d11f5c1aab28c848915b2bec94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "007bf6687150ab0e846dfd5d62500a7afc192c3fdcf6dcdde00d7ab61bfc260e"
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
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end