class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.45.1.tar.gz"
  sha256 "5328ee3bda4e793836834a249ded352482706b71ced4bf930d92611d1d506417"
  license "BSD-3-Clause"
  head "https:github.comvektramockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2b65c252f7ef21612e716b0645c8564c578dacdf6d83ffee9880ff4b3013dab7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b65c252f7ef21612e716b0645c8564c578dacdf6d83ffee9880ff4b3013dab7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b65c252f7ef21612e716b0645c8564c578dacdf6d83ffee9880ff4b3013dab7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b65c252f7ef21612e716b0645c8564c578dacdf6d83ffee9880ff4b3013dab7"
    sha256 cellar: :any_skip_relocation, sonoma:         "d920270d986de65acc345ada94120f96b136285917ebfdba552004f9ec2d9ca0"
    sha256 cellar: :any_skip_relocation, ventura:        "d920270d986de65acc345ada94120f96b136285917ebfdba552004f9ec2d9ca0"
    sha256 cellar: :any_skip_relocation, monterey:       "d920270d986de65acc345ada94120f96b136285917ebfdba552004f9ec2d9ca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc6f29ddd1b42c87954a6165972588c7212b02c5cdf3709873ba7dc447368526"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comvektramockeryv2pkglogging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end