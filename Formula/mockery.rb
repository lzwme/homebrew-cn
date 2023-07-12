class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.32.0.tar.gz"
  sha256 "1252e562ccf874195044ef061be5a3e9897625acb57d75ad82c7ce7fd59d0ba6"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a2dc8c806d166cf2913cf4385f698e66b9c179b5c517b178571451c3af708ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf4ed22f09a13037bbfb1e90c1e27b43f43eb6c100fb580351ce69a66f9806fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "796d22ce8c7e7c0a7715c3fe69dfc52092b2e260fdfc49c7850102f28d0a0e28"
    sha256 cellar: :any_skip_relocation, ventura:        "7c5c21d73020debca0792bc6422c77ce5e25e9c52b1a57c872cbf2818da28668"
    sha256 cellar: :any_skip_relocation, monterey:       "2d32894d264b5b55abd4fcb9e6cddf4f8ef76a987ebd7157a431b38e2e93b9ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "efc01861cab2eb73ae35e2e4b224e3e622d4e9e639e10a25ac5d70379200e0a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3ea48848d7340fcb3fb727e9f98c5379e6c4ac3612336c30f60c9f933c2733b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end