class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://ghproxy.com/https://github.com/aquasecurity/trivy/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "cedf0bb9713ed0f625974a09b889b12223979fa3c8871795612dac71583455ae"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94895b1aefc3b655ebbee2628ba9f99bca52352a1bc56008d2c46a28c141adfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "378da5c7f5cf7c89e04f5084fbafc187f5bad277154686dbcb1d3a1935b8398e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c55f04e6b526b57da37d9d93536773d9df1a378ee0a384f995cff871aec4f8c"
    sha256 cellar: :any_skip_relocation, ventura:        "eb39d756e80c188b37404dc9ea092525581fa5f328506629eb9615c2612579bf"
    sha256 cellar: :any_skip_relocation, monterey:       "bcad0a6a2dff4e3834091b2c492cc22e9051a19dc72739de0af099e8e6975121"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5267a938c9dfce2af1117d11235f88bf96796cbdaafa7ff599c122384c52119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a513258e2a9a055370d76e98d76ec5ae71584f2350792e6ed2bc186d38c0f64"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/trivy"
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end