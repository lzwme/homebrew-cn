class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.23.2.tar.gz"
  sha256 "fb81afae4aaf7a78b82431f13e9c2fdb5a4e89e3bf3c56d8ea8154ff82cf601e"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69bac6f83445a35bdcefc0667515913fe0f9523949afd41edef398b32a5c6614"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43b0104ea05d15132c8695d35584a801a416ad195fe5eca8897b3c4b0c91b769"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "896197af2183047a93837a4f45f2575291e99351d7ed13de797f034488235a27"
    sha256 cellar: :any_skip_relocation, ventura:        "30ede083793d173115c01028cad4d2b04c2ec704c3e3128566970b70d887d00f"
    sha256 cellar: :any_skip_relocation, monterey:       "11a0c6c0eda37168ea75c75b37a135a4d3e6a36652ba63822909c2aae5909ba3"
    sha256 cellar: :any_skip_relocation, big_sur:        "884893aaaf847c7f26d3f0100660f54e94246bfb8e064bbcfe1b56909b296956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1b1ce597440a3ccb4dfd633b349f6c5ec446ffa6ebcc993ce90d2500002ccd9"
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