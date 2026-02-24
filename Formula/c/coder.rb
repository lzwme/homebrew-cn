class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.29.7.tar.gz"
  sha256 "d401455d789c26b6272b7285b7a4fe199cb9bba7a6b551720e530508c95d688c"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c256c8a88957bed2976e72c1ef1a579e062072714588406a8dd87d0d2fa1bf7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa685cf41948940e47c2e545e064efb8ffea0a6ba6f1b20803f6bc993b259927"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25bccae02a6629011f1b86a491d8af19575e2cef2397aa898aa786d5314fe356"
    sha256 cellar: :any_skip_relocation, sonoma:        "933d8cd212099c4c22b3565edb73c22e693b85551455da099a1c6cdfa2f93ee9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8af07172c15181033b42709bd957d5619071215bf81310ac8179ec2de776a4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cbde3fba06f407b92f27c46cc0ce9a56be14fe75391d5d3023594dac1f285f8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end