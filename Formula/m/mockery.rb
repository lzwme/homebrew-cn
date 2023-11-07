class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.36.1.tar.gz"
  sha256 "f4b066b1cf8b3738fa42ff2e21bf85781375dabc067d22784afe14ff3476c79a"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c962ba344f3358f1455383e9aedac5572c747285d9c0943b5b9d7b5c6d59083"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "854ec6f16cede778bc1c671cdd0e00a18764d83951e2c9a9097b645340b52a1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61e9f8eda3836fce0c44f4d5052b94ecb169a3da6ccc79ee4623d3efb10c747a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b19fb4214d0d6d496cb58c9d5fde5db6d8760a112355906d4f06951b1d3e70d9"
    sha256 cellar: :any_skip_relocation, ventura:        "331c34e2828f994741542cc49cb6fc4081aac6009359691729d2bd7a16700491"
    sha256 cellar: :any_skip_relocation, monterey:       "cf18d34052fa0e0b0b6c8b9b10e1d228436c6fd31cc8626cf6f1328411c38201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3a0dc1130188772d0fcc0b677495d68435e448ffb964baf017c04de75d2dd16"
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