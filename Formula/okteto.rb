class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghproxy.com/https://github.com/okteto/okteto/archive/2.16.0.tar.gz"
  sha256 "0c41bfa6c17341bebfa96d0cb66eb9decd81c423ce864e92d22f8a28d08b29ac"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a753e2cf44639746e7e49dc0ec90cae7eb838fb82d48b8e3e711c94b1d203ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be7b73563676af6029cbfe641b25f36868de80138835e62d17b583ff17ecafce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b4460591e121bf37f074137089390e3635b77089487ba1c834a79860d56dfdf"
    sha256 cellar: :any_skip_relocation, ventura:        "6ecb7275add48fd0f5b6eaa86fda30fa83c257c6e152cbbaeab71506ce5ff2de"
    sha256 cellar: :any_skip_relocation, monterey:       "33444ea33bd0428dc53c60d1e4677fe504579bee0b125efabf3d52bfeeda4205"
    sha256 cellar: :any_skip_relocation, big_sur:        "22c42851fe4e7a2e460a40d1afc0e624ea92396532e53e6b2ebb1925f4faf0a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd43bda50da5b21a8456c585c8335e57cfca1ccdc877d868312e4fc5ee2de183"
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