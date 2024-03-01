class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.3.49.tar.gz"
  sha256 "6fb5eb31dca103fd029ebf4d344dfa4e4a909fedadde5287628d0dc702dd6a6b"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96afe15071307a2e374d8aef9e08692ea9949426b948e2941b621ee82e669932"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "729b8f3f4b29b7f7be4c764e68e631d9e9c082656f927fefbeb6e1a8d7d4cdee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf20a2c08cfc648426808abc13b743f416e82120fc0322f9c239f31d54b4d033"
    sha256 cellar: :any_skip_relocation, sonoma:         "a915ddaa21db011aeaf54d2029c8f7351f6bae8826902e035984b30577627fdc"
    sha256 cellar: :any_skip_relocation, ventura:        "f020631c8cc4760c8d52437280a46c6ab0c64d3217965ae069e9b7b8b7b04308"
    sha256 cellar: :any_skip_relocation, monterey:       "28add84fbd51f094165f42bc37e822b571e0fac3dac05527ef918f68ce9c336b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d72b7ef6383449cd876315809451758d179ad39d25d1526592e892622f57bac0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags: ldflags), ".cmdneosync"
    end

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end