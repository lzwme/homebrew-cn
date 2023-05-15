class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.27.1.tar.gz"
  sha256 "fa556a62cdea41b7fd6685e2da481882751d9740c7c1f4d450147c935b42fde8"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0abfc4a03243dcd95b25b0a5f067e233bacbdfdc4c96beae1f0388aec56c639"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4a983723f68ce4b87a47c1498beb29727f614e67733fa760033139e6867d36a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca062b7d6eb576b12c18302d9680345ad71b39dd7b73c7a9be70fbb0d2fc13e0"
    sha256 cellar: :any_skip_relocation, ventura:        "f4eacd23c8da2ca4064d18fbde80f3ab45b7f76143fa36d30b100453df7415d1"
    sha256 cellar: :any_skip_relocation, monterey:       "2bdec599bfdeea6785745cd21c05740d46375957e4aeef23e319c88c5630a5c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f6252f27a2f44fb4e08f1cb4313867fd76b77b1789e73b5b948d4ea0197e904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85f7873609ca17d21f0ddf7026d13ef7be8df9023f429d93ee924de0563736ae"
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