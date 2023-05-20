class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghproxy.com/https://github.com/okteto/okteto/archive/2.15.3.tar.gz"
  sha256 "d89d1dd5b422a31ee6fd4755e07198d296bc591ea8cd5c7556bd7f0f3f15cd0e"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ffe66e7f551102bd2c4996bffde99d3fb27a12956845c68a5d66029ffca0ed2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e12cdca62244abb99d9f386b405436863007c3c12c6e959fb244969abac57a2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6835ccc8f1a4909d40e05678fa25af280b4e5b25f01d4e538541ed518ea73d0d"
    sha256 cellar: :any_skip_relocation, ventura:        "c58437fbd59e4620e8374958bb876654ee21e9cbf6b74996a6035935cce9187c"
    sha256 cellar: :any_skip_relocation, monterey:       "9fbefa0c0a89aa0cfeb6757ae248bad9b3f34a7a2c4bd5d36f8ab9d6d22c081c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e93424e7dd0127bfe014131046348a52549238826a0298f2a475a295e082ab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40099483289b41dfc9d110661d5ad64af02a86cce62c240df0f629bf3aa9d410"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end