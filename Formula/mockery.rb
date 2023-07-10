class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.31.1.tar.gz"
  sha256 "29a7aa3f0ebf7ad8f2dea631a4a2737d3eb68be87672d0c0ac7abc5de5eea2cc"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36574a7897a1b8170b41144915083deabfd5f2c3a9dffc0c00e702e4d91782ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7c2a4a3a24cd3a3d76e2d8f3f15211dc7557f66776b7f593eaf75bd377c4edf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ec2eba0c8a57195563d02f4f49d8e527823e586fc9141353873615f3a0759be"
    sha256 cellar: :any_skip_relocation, ventura:        "a1c0873f32ddbe5413e40550975cb00178aded948c22414629a4ba5ec3fc37e7"
    sha256 cellar: :any_skip_relocation, monterey:       "3469e50b34d76f3f0eeda76d3d4955616fdd1362794b2761e584ce950972f93d"
    sha256 cellar: :any_skip_relocation, big_sur:        "80a8f9ce33ed7b0cafa56072b0883c5bd0848b27c353178395ff2600f24e710c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "168a546a46cca9cae6d8946cbea78621f9d99500821ec597aeab1f7a54183d59"
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