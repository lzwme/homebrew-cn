class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.34.2.tar.gz"
  sha256 "ff169cd347fd2373a2d316d5b1d6aa7556a0473ba2acb13bbd34f0e7a47226eb"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c98b9c2eea901b795e2afcd2f87fb446d4d469e379382f7dcff2fa23d029f630"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "512cb0c965c21724415c54849e1800ba915d5776608ba13a9876be62d2e0e3d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abc23ce1638cac12918befb747ea5ac4f364c6bf5e9c5a9b3f15ecb2b4f33d99"
    sha256 cellar: :any_skip_relocation, sonoma:         "b110bad1bd5468b0bbcfb07e0d9282e33fa4f41cf16effa1e0cc9abecb8dc447"
    sha256 cellar: :any_skip_relocation, ventura:        "f6ed61a508ab7fd1fb96aa9845b702af0f1f155f7b2de6e006547a47eaaaa65f"
    sha256 cellar: :any_skip_relocation, monterey:       "63bb218907f9552e4f881d055e183099a5f498f8f1b6689dc117f77b7a3c7c85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0007a7e10468f28c46008ef5c5ac0b52cbeb8ecc1a22f3d959db6f6cd1331be7"
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