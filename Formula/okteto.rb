class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghproxy.com/https://github.com/okteto/okteto/archive/2.14.1.tar.gz"
  sha256 "300fba32977573a063466ec3f720323eb7fcf7c51e02d719278c92456ea8ee2f"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3f1dfb2a965593dc094b79a97ae4af2cbe4f2d4a3d77d4a36009cec3656dd37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bf626cd12901bc4435b48e01fb3411ab9d20c6f7be6dd9eb71bdebc2478f521"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a4db2d376f7b3b6ff7b36af776aaf7a5342abad686386efdd0969a20611e7fc"
    sha256 cellar: :any_skip_relocation, ventura:        "4c81544a4d85fb1b93da2af26d072d710f4876f9221539fdb5a56e2eaae2d8fe"
    sha256 cellar: :any_skip_relocation, monterey:       "b7d432e28694633e3b317cfc386efee520cfeae0a81df95a3736f5998c4f38ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "c21ea482962de4884188d30d62cab07881ef98d0a7aee9751dac8be3f9aeb62f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dd88b4d1bc4aac2291b155865f96b4b89224639649ab8af414259d1ae4f76ab"
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