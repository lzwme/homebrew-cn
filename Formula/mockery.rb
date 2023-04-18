class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.25.0.tar.gz"
  sha256 "4b62a1df117ceb92b8b67603dc234895107fe8212fc955ad56990d63e0ceae3b"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f223434e42e48ba56e63814c4aea05281886f5de05cf1b5233fc5d359771a30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87cbe904e2ada98ddfcdbb7683b986259722141ae5b98e7f65bf60c5701c4bf3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bde43c3e5c0ff130d64d67432f94e0b978d172761727ee75343a3f6919925ad"
    sha256 cellar: :any_skip_relocation, ventura:        "58dd561233b354967c81234c6dc1be99e0e7bf1cbaf95e8029726087a70e0965"
    sha256 cellar: :any_skip_relocation, monterey:       "9f17e3787bee12e32ab60d01422918479f292361f4742d7336f914e5af8011ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e64448768f2850b555961ba832d2d773635bf7701264a71133ae72b27268319"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1171ddc73a6f9279f34f381575a1768520082b2f9adfc14a8816f77f91777ad"
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