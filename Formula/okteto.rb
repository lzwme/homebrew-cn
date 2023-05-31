class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghproxy.com/https://github.com/okteto/okteto/archive/2.16.1.tar.gz"
  sha256 "9844eadce231f8a4122cc4f4e3b6ce4549cfc13f05cfd532f2e261e817b32b1f"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "273dd7d9a381ba6cda53c676525d967da145cd269fba877cc2a10c6fff73d81e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb74d28e7af8cdadfef07b0ae46c1f2e42411f018da27315509e828d11a53883"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a9d83a874108cd8457a4c77500f8adc5bbf07da6f85622efdb0ad2bbff63e6e"
    sha256 cellar: :any_skip_relocation, ventura:        "533032c0f0c0ba8f4e6b5459f1a5411761462fb68b987d944079b8e846edbc8c"
    sha256 cellar: :any_skip_relocation, monterey:       "e04e4b9b12cf78f8e1aa78bcb7238a3c21057633d41b9b75c84bbf52c28332dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "adeec836966e59abab621255901b26d8a986fbebe5ac0a008f682f2c355ed9e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa563b8b2ceea11ae5cfb4c55f6d63a3b7ce5f99bedddc0f13bd29d6f0e4aed1"
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