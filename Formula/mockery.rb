class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.22.1.tar.gz"
  sha256 "c30e8d968af4a99a2fb46ebd5bc448dc951153d2c17d3c5907f5ccf26cdd81b3"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb972a3e880999f5d25c2cba837d5aa7e56695131031cb481e6344abc2e41a01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa5f6ad4cb373087e12f5ef4b82d211b34f83e3ff080f4bd9ad25111b9cb18a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0afa88708ddb61f66d2d3e806f0238e8eaab5abbe1e5b1cf3f3738387ac8a8b"
    sha256 cellar: :any_skip_relocation, ventura:        "fb7093573cbd381c9b41d1e14cb9e94e1618c9ae91067d2a951cbbc61a22f167"
    sha256 cellar: :any_skip_relocation, monterey:       "a99899feb4b89202b15be0243c900867f49b13e2d094607bfde28ead6a3ac474"
    sha256 cellar: :any_skip_relocation, big_sur:        "92051c5c7ea41993328ee12c00f6da064b8e31b201606e250b724b8f3296ff80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95dc6a09898b81d54b1b66087e6da96ce6731c748ca7a527fda2dff6d15a526b"
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