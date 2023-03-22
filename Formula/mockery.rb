class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.23.1.tar.gz"
  sha256 "9172cbc0f722047175fc030b61adef9a74ec2d35ca1fc1d9cbc53fb0b4faf27d"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d68f863d1c595bf279ad97c043573e34d7d8d430671218cc14066fbeda9fc9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f41f96f9570699babb451105bf678bb07cc7038c5c5618ef2c23a2579d9c1b64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa216135ee0cf21e058d249b1341dfd923362f3b9d36572323ed1238bccda428"
    sha256 cellar: :any_skip_relocation, ventura:        "88fd836ae2cf71e0aa006d27b4a8158c538b86e5ff3ed3a17b6d58673241b42f"
    sha256 cellar: :any_skip_relocation, monterey:       "d6ad6562438cf79d8e71b6732dbfd5e04de4bbc64f87806a75457b1f22676d0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "44efca1d5629fe9df62365beabde18ed739721d932730bb7ad9053b638333a09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cb7c55e1b2cf2da959f134ee6740d4b820eaa47c2798a212caa0395d5b103b7"
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