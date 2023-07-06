class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghproxy.com/https://github.com/okteto/okteto/archive/2.17.0.tar.gz"
  sha256 "7b5e7b7b37bc8de667d6f7544519a8f8b40f929719f80d0c4c1371715a30b8c1"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9666bfadcebe976b37f36f4446c7f15fcebafcda145884122a881a2e3772c6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afc56ebcffac3916fa4e54b2fde6d1588f0adeb0d4fab4a20035a9a982a2da16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7061074b694c25db5ee7228c70b2aa908ba95ebb34e9859b2990b94ac64fdfff"
    sha256 cellar: :any_skip_relocation, ventura:        "ead208e7a87f91ba9c9bfe2c69d79cd5bcc34a008c70bef92787bf3f253f5206"
    sha256 cellar: :any_skip_relocation, monterey:       "c0e516db469e538d676154b4a3291998ef4abfe8ee4047a11378ef2adaa6f613"
    sha256 cellar: :any_skip_relocation, big_sur:        "4233d8b14c9df2080b8f86e4424fe45ae1de095a169c0602180735ff7cbc5efb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "733dc6bd03d587f34163cd820508a0ae7b39ec9d73f8a4445d7be1fd80bc73d1"
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