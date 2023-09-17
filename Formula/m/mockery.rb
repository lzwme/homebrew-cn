class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.33.3.tar.gz"
  sha256 "8bc2e62c28882b51a1b84e5371e2b0e59938f01959fe6d4c932d076982adc7a8"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3dc098764f6802a838ac35f47bb759c7ff2bfa6185308c26c8f2dbe42cc59633"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58a96fefd787a72d121912cc6e6b6f4e41371ce1cd991598007a437623ab04b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cdb25cd7302410829fa9283a6c16340d2ea312fda0f01ad71c67c71b5140cf8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61a2391a6858f87771b61a1fab3e1617554de61899c546ba5289cee4f58582c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "222dba7e179bf81cd88fbab5eea9407989e510dd61c0ddd189d07d78cb09f627"
    sha256 cellar: :any_skip_relocation, ventura:        "93c763bb390349851e401e3c2a9c1a3a7d2fafe8aa45cbb6eb2643856909b4a4"
    sha256 cellar: :any_skip_relocation, monterey:       "4a6b59067c3a302aa4d81a9acec51779cc7cbee96424d17ff7203132e03646fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "955e7b134b32682da6e4bfd44f41b4bf839c97a261243793fe8dbedbfe0fb0c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2cf7023d9800afad50abca96014e7eadd4d8e667be31d5853b72119556eb9ef"
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