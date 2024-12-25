class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.50.1.tar.gz"
  sha256 "d83b4d518a05f55debd9f57555697de114c32e3b3bc1dfb628e4ae4e939c1528"
  license "BSD-3-Clause"
  head "https:github.comvektramockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf2cd9a4e476ddf2c3655a4bdf58f5bb44dd5ca6bf3e0d2903ca4381a99096cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf2cd9a4e476ddf2c3655a4bdf58f5bb44dd5ca6bf3e0d2903ca4381a99096cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf2cd9a4e476ddf2c3655a4bdf58f5bb44dd5ca6bf3e0d2903ca4381a99096cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7dd84f7615a45e063dd2c2b9478695c69e8ab2360bb1fc06bfa65297e37148a"
    sha256 cellar: :any_skip_relocation, ventura:       "f7dd84f7615a45e063dd2c2b9478695c69e8ab2360bb1fc06bfa65297e37148a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d71f8eafa048697b5cd4f6b7c2a0ac4140a7319019be0ac696bed03998235ef"
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