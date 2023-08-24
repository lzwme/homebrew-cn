class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghproxy.com/https://github.com/okteto/okteto/archive/2.19.1.tar.gz"
  sha256 "786dec607c6095906bdb410e6ec5ecc8ff00d02a4008f42fbde2e4f6e4cfbb0c"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d2615382a254054c0b9995d7ceba6a96eb9e92b14f296b0509af6be07cb9ce4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0066041c8441528e4fa024addbf10a43429a9285eb8680a300a9397427533ce5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9162184a494bb4b516cb0a7698a21a0b2a88d76b5cd7ffae3a9d8717bcfce79"
    sha256 cellar: :any_skip_relocation, ventura:        "8701b0b751088478c513c41351d3d2fc757e49d7b53ffdb68a599173256da9fb"
    sha256 cellar: :any_skip_relocation, monterey:       "7c5e8a3e5a309f56c05fad5b23572e22e960381c1a532fc0dcbf48adec5dd9d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "836df7fccda17ce4c1ac21addd82bc888bfd46bdcf97b2e6a582771b17bfe8de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c97a1b166c0e1059ee81fd5bfd9e8e330d6c20e1699cccc70a53cac1f9f59ca"
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