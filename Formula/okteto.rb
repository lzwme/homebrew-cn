class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghproxy.com/https://github.com/okteto/okteto/archive/2.16.2.tar.gz"
  sha256 "69e112a60c3476ea073d33a4827caef2bf9c25933a34581cce3bc964187509c1"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "756e0995108503e9d9fb62e9399fcaad30e2371539cc252e489a624347d2e4a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc1a77fe697ed73756f6c471365fc16382dfaf0ecf81c69add30bbb8e447ee0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8e3a617b9ee61328708b3636d830ac87b0e9b7cdd27863013fef7d50b99539c"
    sha256 cellar: :any_skip_relocation, ventura:        "c34ec8207163248e0853a4d81d7863e3dfa38f1db067e3fff8051f7672d85511"
    sha256 cellar: :any_skip_relocation, monterey:       "5efb804ed7fe0b5dc6a8323290b4c4c3cc50f165a39461ab635fb765411e9ccf"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cecce1103475e36e9f3906f26655a8dffd16f842e950aaf3df610d46a3c42fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd97126a9d28fd3836e709a4327e9a0ead973858196918f284e08d362702f9d8"
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