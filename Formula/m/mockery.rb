class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.37.0.tar.gz"
  sha256 "4e1b3dbe8392e84f3e8ee19670f0773c4f96111f681f0db05018feac12f92bd2"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0628d5d6c993f0648e4a5c9282e7750ac8c1d0d726add5e21126885965a88422"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87b88d646f4f86e389c18b9066f755c43d999b6fb94a6583c80f6bb286633e85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03f58a6b72900f9710df44269e15200e4f780f13a401abf48eddf8b888a7f85e"
    sha256 cellar: :any_skip_relocation, sonoma:         "4672d137f68991ff035b2e21d2a7ec76dce945e50b3b68b274341edf0ea6d09f"
    sha256 cellar: :any_skip_relocation, ventura:        "e46bbc476bc18ff17dda158f2c40e85b4e268f4c16d75f05609047ccb42babc3"
    sha256 cellar: :any_skip_relocation, monterey:       "8f7fc0a2b23f19d97fe7876000dbd836ea0e43083c06b0eed894dddf1491d950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a4661b18a054985dc0b8a3f01f823db627246a7524988bc8fed047269d8efe9"
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