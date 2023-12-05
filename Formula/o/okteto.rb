class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghproxy.com/https://github.com/okteto/okteto/archive/refs/tags/2.23.0.tar.gz"
  sha256 "a7f137945d7dbabf117fc78983aea167f07f28b6f2909c338be5c71ade65c210"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f291f0c0f2d2236f2db214df39972094947a6346270b0c634cc92fb897bf2be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a84d92f483bd820b97dbfc9166a6580c1d6eb74e33c4d56cabb855e28b72b37b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc1f04f20470113cd13edc37cdcc4023ae8e7c9cd3e63387ab3a37f2fa1e346f"
    sha256 cellar: :any_skip_relocation, sonoma:         "044fbbbcb9b49a9c4b1e55846860b896f9bdf7f95126f585182a5d7dce557e22"
    sha256 cellar: :any_skip_relocation, ventura:        "ae53489ff7926b032c6e378649acc4b21ef6969fa5a38e2c2e901e4892a290fa"
    sha256 cellar: :any_skip_relocation, monterey:       "3ff7f1c0c4621fe248ec9e08fd2ea0882d81e9ac4b038395ccf3d17b445c13cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f80a59b9b7c81a8c9dd26a51d64a6fdfdaf320787802f56bfbc85f33ee86adb7"
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