class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.24.0.tar.gz"
  sha256 "b8fcb80796c826db67dcd7a41b322ad736222e21db820272899d9c7693096f2a"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eac506ce968072c9e7f29c6c83729e8c9fd93d65f53ebe6c33bec1ff193d31df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89c5fceceab1251f4c314d49287fee476ea44b66bb80bf8e823d2769168553d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75d8d26560e2e64e4dbeb5aa0b2927da61a3ccb12507ee74dd94407cb25c01ed"
    sha256 cellar: :any_skip_relocation, ventura:        "668e50f5e187db1d844f9cdd2199cd3e5e14de72b5134f4d71527982186a3130"
    sha256 cellar: :any_skip_relocation, monterey:       "ac7ae38ce821f30d15bcb3cabc2c9f22448e1797a40717b201c0f1a18734c51b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3809225e20e89a3701717245e1c36f035c0d9b0ed2328d618732929f7f9797cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "008c516877c069dfe346f050379d74264c33fd41b4be78cefb3d098a95512a6e"
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