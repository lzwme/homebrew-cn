class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.30.18.tar.gz"
  sha256 "e80d03cc8175a7583afac417f6bb1e6aa9219972e2c6cde26097a798c220e1e4"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69494f0a8ca8439b772e258a7633002b091f029d39deef5a007dfa82b0617f2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b289507e485162bca5babf942a0033866b86a48d3c27c5a0181221f005020098"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "857739a6ff092b1403164e52f911b3ff5af3554b370e20bd1e7e497f70db245e"
    sha256 cellar: :any_skip_relocation, ventura:        "0ab5bfd323f97eb729138bb9b7cd7a4317ed6530cf7649ba999690414b6954fd"
    sha256 cellar: :any_skip_relocation, monterey:       "8c92a85ad26eac4da0329d7cac2a2b84b15247b12c3fcc79c03681278a1ee764"
    sha256 cellar: :any_skip_relocation, big_sur:        "839baa9a9858ff8f2c0a124150704b089c5f6aae85e682a7d243e8ae32b576e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5740970ae7521b931ccd69a29cdaa45d70bf9a1b054d3db9bd7b61103b5ce6c8"
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