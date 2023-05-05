class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghproxy.com/https://github.com/okteto/okteto/archive/2.15.2.tar.gz"
  sha256 "c97ea280a5f4759b002e04486b0029dff325261b8f58c8a5cc8a95838a27b9f4"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce65febc4a63130f8a2d6de0fb469a1d3d6f792f0f5b183db71cad9cf4b5ff49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c822a15a2327573415f38765892ce0269ceac859028457764ad301e59fa9929"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9765b4efa0a05b2f8875693ca089d37422f4e5c2acf365f478a7e02a99ecd1c8"
    sha256 cellar: :any_skip_relocation, ventura:        "bb9ca14d78f4824aa460c7bcc0ab3bdb535f61b31f0954907b7abaf6f387053a"
    sha256 cellar: :any_skip_relocation, monterey:       "cc98ccea5a7e60265ccc883e947fa9e81e56aff9f09887548568997d729dd282"
    sha256 cellar: :any_skip_relocation, big_sur:        "d75585a41f3ca53b5387c06617f803d2fb93df7bb3bdc2ae9991a72f5aafab15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd2054fea8fbb0534259ae275b490e90888cfe1fe59a332ea70e5d9e4d9d644b"
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