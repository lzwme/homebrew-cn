class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghproxy.com/https://github.com/okteto/okteto/archive/refs/tags/2.23.1.tar.gz"
  sha256 "5e4e1eeae86e9e93f73fa513cba467a91c5d7a187e15c3f4b256efca158a9abd"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5f4310770abee7108d7a1f02ac8bdc52df8299e7baac9eb4d6c3dc8d461f6be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25fd07cb35131b93d351a2bd6c82fb26192115902877ddccce4eedd05133a244"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "447c1ef93ef7f3876e87237c3ddc230a1f64fd0d5840ac0ea484daca2860acd2"
    sha256 cellar: :any_skip_relocation, sonoma:         "e56c3364269863913e80df863fbadea71f8cda2f2f799ee966aadeb5ea3b46da"
    sha256 cellar: :any_skip_relocation, ventura:        "5a8eaed6731cc5f0b1413b2808ee9aab611fb447ff56b573c85a4caa3b946dda"
    sha256 cellar: :any_skip_relocation, monterey:       "a10544848e8c3988d32da13628bdc3ffb11c7d831e221bd428e2295df5d32e15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "198905aaceea402a97bb693a153dea4f237c1c72d68d350c68d024cd64be6086"
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