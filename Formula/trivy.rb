class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://ghproxy.com/https://github.com/aquasecurity/trivy/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "375e2e53c58cf84896c0678a9c16e907a78ffaf943339463edb63f42f3aab5a8"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e86e7f0774b5c60ad80d100f6b4d045088b8237595a5d6efc5421e4bbaba0c17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67ba80ea14eaa7185ac34c6e11b32012a1821c2f09799f69ad5caeedb9832eab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc6dbd1afeb5046effbfac9e7268e702a1d998d90ab95534b746c8e56183677c"
    sha256 cellar: :any_skip_relocation, ventura:        "783f0126a04f704c9e452561d71c8838598aea5c6807a769d65b92a6e9e49592"
    sha256 cellar: :any_skip_relocation, monterey:       "e68789043517b32fa63eb4a168d3ace1cbf347f9ac99923e1f6baae117f19da1"
    sha256 cellar: :any_skip_relocation, big_sur:        "2787bcc83980fff9e394a53da5d0d63f856ef99b5fea1948de8324f234093229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d2d176c0c068c538cd099194c52673b9fe99c1561e99b08ab169f8c2b953d4f"
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