class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghproxy.com/https://github.com/okteto/okteto/archive/2.14.3.tar.gz"
  sha256 "6451623274f50e326a75f7bc6817eda936cedf6b142ebb7064ea5f35586630df"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba01006e34fe8549de933b6fa8c5680bbf3a31e9848b14ac52da62b0109ac99f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5347cd84db724f0e6f2327d1ca16f0ed55976054a124d4aec282eafaf1a9c54a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6f2a95948bd166c11c7b3b4be8b8258ddf0688d38559976a45a303e95f36b93"
    sha256 cellar: :any_skip_relocation, ventura:        "c5a8cfd06ead0d48431e5f8b9e0e0b6e663c2671044fce80115f99f515e64118"
    sha256 cellar: :any_skip_relocation, monterey:       "ea0e698b699edbfe0615e842b9797d0876cc32f3562c2b499cff7f89dfb363ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "efa51fef6f31d3d789c23a9cf0224cf4c4d28cc60fc364f7aab90d83e71e5c6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d8e51fa4ce0e2fb6a140658ac9a100047fa01206ae300a8e9eae62d475cb3eb"
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